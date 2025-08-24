Param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Resolve repo root (parent of the scripts directory)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $scriptDir

# New Domain Check mega menu block (with consistent spaces-only indentation)
$replacement = @"
                            <!--domain check start-->
                            <li class="nav-item hs-has-mega-menu custom-nav-item" data-max-width="600px" data-position="right">
                                <a id="domainMegaMenu" class="nav-link custom-nav-link main-link-toggle" href="JavaScript:Void(0);" aria-haspopup="true" aria-expanded="false">Domain Check</a>
                                <!--domain mega menu start-->
                                <div class="hs-mega-menu main-sub-menu u-header__mega-menu-position-right-fix--md" aria-labelledby="domainMegaMenu">
                                    <div class="mega-menu-wrap">
                                        <span class="sub-menu-title">Find Your Domain</span>
                                        <form action="domain-search-result.php" class="domain-search-form mt-3">
                                            <div class="input-group">
                                                <input type="text" name="domain" class="form-control" placeholder="example.com" />
                                                <div class="input-group-append">
                                                    <button class="btn search-btn btn-hover d-flex align-items-center" type="submit">
                                                        <span class="ti-search mr-2"></span> Search
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                        <div class="domain-list-wrap mt-4">
                                            <ul class="list-inline domain-search-list">
                                                <li class="list-inline-item"><img src="assets/img/com.png" alt="com" width="70" class="img-fluid" /></li>
                                                <li class="list-inline-item"><img src="assets/img/net.png" alt="net" width="70" class="img-fluid" /></li>
                                                <li class="list-inline-item"><img src="assets/img/org.png" alt="org" width="70" class="img-fluid" /></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <!--domain mega menu end-->
                            </li>
                            <!--domain check end-->
"@

# Regex pattern to replace the entire Elements menu block
$pattern = '(?s)\s*<!--elements start-->.*?<!--elements end-->'

# Target .html and .php at repository root only (exclude subdirs like assets/libs)
$targets = Get-ChildItem -LiteralPath $root -File | Where-Object { $_.Extension -in @('.html', '.php') }

foreach ($file in $targets) {
  $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
  if ($content -match '<!--elements start-->') {
    $newContent = [regex]::Replace($content, $pattern, $replacement)
    if ($newContent -ne $content) {
      Set-Content -LiteralPath $file.FullName -Value $newContent -Encoding UTF8
      Write-Host "Updated: $($file.Name)"
    }
  }
}

Write-Host "Completed updating Domain Check menu where applicable."


