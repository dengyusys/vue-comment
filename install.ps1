# Vue Comment Plugin Installer for Windows
# 将vue-comment.vim插件安装到vim插件目录

Write-Host "Vue Smart Comment Plugin 安装程序" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

# 获取用户主目录
$userHome = $env:USERPROFILE
$vimfilesPath = Join-Path $userHome "vimfiles"
$pluginPath = Join-Path $vimfilesPath "plugin"

Write-Host "检查vim目录..." -ForegroundColor Yellow

# 检查vimfiles目录是否存在
if (-not (Test-Path $vimfilesPath)) {
    Write-Host "创建vimfiles目录: $vimfilesPath" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $vimfilesPath -Force
}

# 检查plugin目录是否存在
if (-not (Test-Path $pluginPath)) {
    Write-Host "创建plugin目录: $pluginPath" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $pluginPath -Force
}

# 复制插件文件
$sourceFile = Join-Path $PSScriptRoot "vue-comment.vim"
$destFile = Join-Path $pluginPath "vue-comment.vim"

if (Test-Path $sourceFile) {
    try {
        Copy-Item $sourceFile $destFile -Force
        Write-Host "✓ 插件安装成功!" -ForegroundColor Green
        Write-Host "  文件位置: $destFile" -ForegroundColor Gray
        Write-Host ""
        Write-Host "使用说明:" -ForegroundColor White
        Write-Host "1. 打开任意.vue文件" -ForegroundColor Gray
        Write-Host "2. 将光标放在要注释的行上" -ForegroundColor Gray
        Write-Host "3. 按 'gcc' 来切换注释状态" -ForegroundColor Gray
        Write-Host ""
        Write-Host "插件会根据光标位置自动选择注释类型:" -ForegroundColor White
        Write-Host "  - <template>: HTML注释 <!-- -->" -ForegroundColor Gray
        Write-Host "  - <script>: JavaScript注释 //" -ForegroundColor Gray
        Write-Host "  - <style>: CSS注释 /* */" -ForegroundColor Gray
    }
    catch {
        Write-Host "❌ 安装失败: $_" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "❌ 错误: 找不到源文件 vue-comment.vim" -ForegroundColor Red
    Write-Host "   请确保此脚本在包含vue-comment.vim的目录中运行" -ForegroundColor Gray
    exit 1
}

Write-Host ""
Write-Host "安装完成! 重启vim即可使用插件。" -ForegroundColor Green