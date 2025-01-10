return {
  "nvim-java/nvim-java",
  dependencies = {
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    -- Basic Java setup
    require("java").setup({
      -- Java Language Server settings
      jdtls = {
        -- Set JDK home path
        java_home = vim.fn.expand("$JAVA_HOME"),
        -- Settings for code completion
        completion = {
          enabled = true,
          guessMethodArguments = true,
        },
        -- Source code actions
        sources = {
          organizeImports = {
            starThreshold = 99,
            staticStarThreshold = 99,
          },
        },
        -- Code formatting settings
        formatting = {
          settings = {
            profile = "GoogleStyle",
            url = vim.fn.expand("$HOME/.config/nvim/java-formatter.xml"),
          },
        },
      },

      -- Testing configuration
      test = {
        -- Configure test runner
        runner = "junit",
        -- Auto open test results
        autoOpenResults = true,
        -- Test result display format
        resultFormat = "compact",
      },

      -- Debugging configuration
      dap = {
        -- Hot code replacement
        hotCodeReplace = "auto",
        -- Console settings
        console = "integratedTerminal",
        -- Exception breakpoints
        exceptionBreakpoint = {
          caught = true,
          uncaught = true,
        },
      },

      -- UI Configuration
      ui = {
        -- Code lens
        codelens = true,
        -- Diagnostics signs
        diagnostics = {
          signs = true,
          underline = true,
          virtual_text = true,
        },
        -- Hover documentation
        hover = {
          enabled = true,
          border = "rounded",
        },
      },
    })

    -- LSP Configuration
    local lspconfig = require("lspconfig")
    lspconfig.jdtls.setup({
      root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git"),
      -- Enhanced capabilities
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      -- Custom settings
      settings = {
        java = {
          -- Code generation settings
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            hashCodeEquals = {
              useInstanceof = true,
            },
          },
          -- Compilation settings
          compile = {
            nullAnalysis = {
              nonnull = { "javax.annotation.Nonnull", "org.eclipse.jdt.annotation.NonNull" },
              nullable = { "javax.annotation.Nullable", "org.eclipse.jdt.annotation.Nullable" },
            },
          },
          -- Project settings
          project = {
            resourceFilters = { "node_modules", ".git", "target", "build" },
          },
        },
      },
    })

    -- Key mappings for Java development
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "<leader>ji", "<cmd>lua require('jdtls').organize_imports()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<leader>jt", "<cmd>lua require('jdtls').test_class()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<leader>jn", "<cmd>lua require('jdtls').test_nearest_method()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<leader>jd", "<cmd>lua require('jdtls').debug_test()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<leader>jr", "<cmd>lua require('jdtls').code_action(false, 'refactor')<CR>", opts)
  end,
}
