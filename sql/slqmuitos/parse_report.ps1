$content = Get-Content "D:\gerenciarstock\sql\estoquehoje.sql" -Raw -Encoding UTF8

# --- Parse produtos ---
$produtos = @{}
$pattern = "INSERT INTO produtos \(id, nome, categoria, qtd, qtd_minima, preco, tipo\) VALUES \((\d+), '(.+?)', '(.+?)', ([\d.]+), [\d.]+, ([\d.]+), '(.+?)'\)"
[regex]::Matches($content, $pattern) | ForEach-Object {
    $produtoId = [int]$_.Groups[1].Value
    $nome = $_.Groups[2].Value
    $categoria = $_.Groups[3].Value
    $qtd = [decimal]$_.Groups[4].Value
    $preco = [decimal]$_.Groups[5].Value
    $produtos[$produtoId] = @{ nome=$nome; categoria=$categoria; qtd=$qtd; preco=$preco }
}

# --- Parse venda_itens ---
$vendaItens = @{}
# Simpler pattern: match the line structure more flexibly
$lines = $content -split "`n"
foreach ($line in $lines) {
    if ($line -notmatch "INSERT INTO venda_itens") { continue }
    
    # Extract fields using simpler regex
    if ($line -match "produto_id, produto_nome, qtd, preco_unitario, recheio\) VALUES \(\d+, \d+, (\d+|NULL), '(.+?)', ([\d.]+), ([\d.]+), ") {
        $pidStr = $Matches[1]
        $pnome = $Matches[2]
        $qtd = [decimal]$Matches[3]
        $punit = [decimal]$Matches[4]
        
        if ($pidStr -eq "NULL") { continue }
        $produtoId = [int]$pidStr
        
        if (-not $vendaItens.ContainsKey($produtoId)) {
            $vendaItens[$produtoId] = @{ nome=$pnome; total_vendidos=0; preco_unit=$punit }
        }
        $vendaItens[$produtoId].total_vendidos += $qtd
        $vendaItens[$produtoId].preco_unit = $punit
    }
}

# --- Combine ---
$allProducts = @{}
foreach ($kv in $produtos.GetEnumerator()) {
    $id = $kv.Key
    $allProducts[$id] = @{
        nome = $kv.Value.nome
        categoria = $kv.Value.categoria
        estoque = $kv.Value.qtd
        preco = $kv.Value.preco
        vendidos = 0
    }
}
foreach ($kv in $vendaItens.GetEnumerator()) {
    $id = $kv.Key
    if ($allProducts.ContainsKey($id)) {
        $allProducts[$id].vendidos = $kv.Value.total_vendidos
        $allProducts[$id].preco = $kv.Value.preco_unit
    } else {
        $allProducts[$id] = @{
            nome = $kv.Value.nome
            categoria = "N/A"
            estoque = 0
            preco = $kv.Value.preco_unit
            vendidos = $kv.Value.total_vendidos
        }
    }
}

# Filter: estoque > 0 OR vendidos > 0
$results = @()
foreach ($kv in $allProducts.GetEnumerator()) {
    $p = $kv.Value
    if ($p.estoque -gt 0 -or $p.vendidos -gt 0) {
        $results += [PSCustomObject]@{
            id = $kv.Key
            nome = $p.nome
            categoria = $p.categoria
            estoque = $p.estoque
            vendidos = $p.vendidos
            preco = $p.preco
            faturamento = [math]::Round($p.vendidos * $p.preco, 2)
        }
    }
}

# Sort: vendidos desc, then estoque desc
$results = $results | Sort-Object -Property @{Expression={$_.vendidos}; Descending=$true}, @{Expression={$_.estoque}; Descending=$true}

# Output table
Write-Host ""
Write-Host ("=" * 130)
Write-Host ("{0,-35} {1,-22} {2,12} {3,12} {4,12} {5,14}" -f "Produto", "Categoria", "Estoque Atual", "Vendidos", "Preco Un.", "Faturamento")
Write-Host ("=" * 130)

$totalEstoque = 0
$totalVendidos = 0
$totalFaturamento = [decimal]0
$countWithStock = 0
$countSold = 0

foreach ($r in $results) {
    $precoStr = "R$ {0:N2}" -f $r.preco
    $fatStr = "R$ {0:N2}" -f $r.faturamento
    Write-Host ("{0,-35} {1,-22} {2,12} {3,12} {4,12} {5,14}" -f $r.nome, $r.categoria, $r.estoque, $r.vendidos, $precoStr, $fatStr)
    $totalEstoque += $r.estoque
    $totalVendidos += $r.vendidos
    $totalFaturamento += $r.faturamento
    if ($r.estoque -gt 0) { $countWithStock++ }
    if ($r.vendidos -gt 0) { $countSold++ }
}

Write-Host ("=" * 130)
Write-Host ""
Write-Host "RESUMO:"
Write-Host "  Produtos com estoque > 0:    $countWithStock"
Write-Host "  Produtos vendidos:           $countSold"
Write-Host "  Total itens em estoque:      $totalEstoque"
Write-Host "  Total itens vendidos:        $totalVendidos"
Write-Host ("  Faturamento total:           R$ {0:N2}" -f $totalFaturamento)
