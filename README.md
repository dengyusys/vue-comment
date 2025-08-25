# Vue Smart Comment Plugin

一个用于Vim的Vue.js智能注释插件，能够根据光标位置自动选择合适的注释方式。

## 功能特点

- **智能检测**：自动检测当前光标是在 `<template>`、`<script>` 还是 `<style>` 区块内
- **多种注释格式**：
  - Template区块：使用HTML注释 `<!-- -->`
  - Script区块：使用JavaScript单行注释 `//`
  - Style区块：使用CSS注释 `/* */`
- **切换注释**：可以添加或移除注释

## 安装方法

### 使用vim-plug插件管理器
在你的 `.vimrc` 文件中添加：
```vim
Plug 'dengyusys/vim-comment'
```

## 使用方法

1. 打开一个 `.vue` 文件
2. 将光标移动到要注释的行
3. 按 `gcc` 来切换注释状态

## 示例

### Template区块
```vue
<template>
  <div>Hello World</div>  <!-- 按gcc后变成 -->
  <!-- <div>Hello World</div> -->
</template>
```

### Script区块
```vue
<script>
  console.log('Hello')  // 按gcc后变成
  // console.log('Hello')
</script>
```

### Style区块
```vue
<style>
  .class { color: red; }  /* 按gcc后变成 */
  /* .class { color: red; } */
</style>
```

## 性能说明（AI评估）

- **适用场景**：日常开发的所有场景
- **性能**：小文件无延迟，大文件可能有轻微延迟（通常<100ms）
- **内存占用**：最小

## 自定义快捷键

如果你想使用不同的快捷键，可以在 `.vimrc` 中添加：
```vim
autocmd FileType vue nnoremap <buffer> <your-key> :call VueSmartComment()<CR>
```

## 备注

⚠️ **重要提醒**：本插件代码完全由Claude AI生成，作者为vim初级用户。虽然已经过基本测试，但可能存在未发现的问题或不符合vim最佳实践的地方。

如果您在使用过程中遇到问题或有改进建议，欢迎提出反馈。由于作者vim经验有限，可能无法及时解决复杂的技术问题，建议有经验的用户根据需要进行自定义修改。

## 许可证

MIT License
