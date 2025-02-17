if !exists('g:lspconfig')
  finish
endif

lua << EOF
  vim.lsp.set_log_level("error")
EOF

lua << EOF
local nvim_lsp = require('lspconfig')
local protocol = require'vim.lsp.protocol'

local opts = { noremap=true, silent=true }

vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

  -- formatting

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[augroup END]]
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  end


  -- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
 cmp.setup({
    window = {
       completion = cmp.config.window.bordered(),
       documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true 
      }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
        elseif luasnip.expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
        elseif luasnip.jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
        else
          fallback()
        end
      end,
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })
  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.preselectSupport = true
-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
-- capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   },
-- }

capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

nvim_lsp.flow.setup {
  capabilities = capabilities,
  on_attach = on_attach
}


nvim_lsp.jdtls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
    cmd = {'/home/alireza/Apps/JDTLS/bin/jdtls'}
}

nvim_lsp.clangd.setup{
  capabilities = capabilities,
  on_attach = on_attach
  -- cmd = { "clangd", "--no-cuda-version-check" }
}

nvim_lsp.ansiblels.setup{
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    },
  capabilities = capabilities,
}

nvim_lsp.bashls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.cmake.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.dockerls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.solidity_ls.setup{
  filetypes = { "solidity", "sol" }
}

nvim_lsp.java_language_server.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.pylsp.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    },
  settings = {
    pylsp = {
      plugins = {
        isort = {
          enabled = true
        },
        ruff = {
          enabled = true,  -- Enable the plugin
          formatEnabled = true,  -- Enable formatting using ruffs formatter
          unsafeFixes = false,  -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

          -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
          lineLength = 120,  -- Line length to pass to ruff checking and formatting
          exclude = { "__about__.py" },  -- Files to be excluded by ruff checking
          preview = false,  -- Whether to enable the preview style linting and formatting.
        },
      }
    }
  }
}

-- nvim_lsp.rls.setup {
--   capabilities = capabilities,
--   on_attach = on_attach,
--   settings = {
--     rust = {
--       unstable_features = true,
--       build_on_save = false,
--       all_features = true,
--     },
--   },
--   flags = {
--       debounce_text_changes = 150,
--     }
-- }

nvim_lsp.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    },
  flags = {
      debounce_text_changes = 150,
    }
})

nvim_lsp.sqlls.setup {
 -- cmd = { "sql-language-server", "up", "--method", "stdio" },
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.terraformls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.opencl_ls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}


nvim_lsp.vimls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.vuels.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.gopls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.yamlls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    yaml = { 
      completion = true,
      format = {
        enable = true
      },
      schemas = {
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json"] = "/*.yaml"
     },
      schemaDownload = { 
        enable = true
      },
      validate = false,
    }
  },
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  flags = {
      debounce_text_changes = 150,
    }
}

nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'markdown', 'pandoc', 'python', 'c', 'cpp', 'bash', 'sh'},
  init_options = {
    linters = {
      eslint = {
        command = 'eslint_d',
        rootPatterns = { '.git' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint_d',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
    },
    filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
    },
    formatters = {
      eslint_d = {
        command = 'eslint_d',
        args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
        rootPatterns = { '.git' },
      },
      prettier = {
        command = 'prettier',
        args = { '--stdin-filepath', '%filename' }
      }
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'eslint_d',
      javascriptreact = 'eslint_d',
      json = 'prettier',
      scss = 'prettier',
      less = 'prettier',
      typescript = 'eslint_d',
      typescriptreact = 'eslint_d',
      json = 'prettier',
      markdown = 'prettier',
    }
  }
}

-- nvim_lsp.CopilotChat.setup{
--   capabilities = capabilities,
--   on_attach = on_attach,
--   flags = {
--       debounce_text_changes = 150,
--     }
-- }


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    -- This sets the spacing and the prefix, obviously.
    virtual_text = {
      spacing = 4,
      prefix = ''
    }
  }
)

EOF
