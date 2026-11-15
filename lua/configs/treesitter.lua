local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then return end

-- nvim-treesitter's frozen `master` branch expects match[id] to be a single
-- node, but Neovim 0.12 always passes a list of nodes. Give its query handlers
-- and match iterator the single node they expect, which also fixes
-- textobjects. Remove this when moving to the `main` branch.
if vim.fn.has('nvim-0.12') == 1 then
  local function single_nodes(match)
    local nodes = {}
    for id, captured in pairs(match) do
      nodes[id] = captured[#captured]
    end
    return nodes
  end

  local function with_single_nodes(add)
    return function(name, handler, opts)
      add(name, function(match, ...)
        return handler(single_nodes(match), ...)
      end, opts)
    end
  end

  local query = require('vim.treesitter.query')
  local add_predicate, add_directive = query.add_predicate, query.add_directive
  query.add_predicate = with_single_nodes(add_predicate)
  query.add_directive = with_single_nodes(add_directive)
  package.loaded['nvim-treesitter.query_predicates'] = nil
  require('nvim-treesitter.query_predicates')
  query.add_predicate, query.add_directive = add_predicate, add_directive

  local ts_query = require('nvim-treesitter.query')
  local iter_prepared_matches = ts_query.iter_prepared_matches
  ts_query.iter_prepared_matches = function(parsed, ...)
    local single_node_query = setmetatable({
      iter_matches = function(_, ...)
        local matches = parsed:iter_matches(...)
        return function()
          local pattern, match, metadata = matches()
          if pattern then
            return pattern, single_nodes(match), metadata
          end
        end
      end,
    }, { __index = parsed })
    return iter_prepared_matches(single_node_query, ...)
  end
end

configs.setup({
  ensure_installed = {
    'lua', 'python', 'javascript', 'typescript', 'html', 'css', 'json', 'yaml',
    'bash', 'dockerfile', 'gitignore', 'markdown', 'markdown_inline', 'regex', 'vim'
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aB"] = "@block.outer",
        ["iB"] = "@block.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})