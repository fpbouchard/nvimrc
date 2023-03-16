return {
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup {}
    local cmp = require 'cmp'
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )

    -- Add spaces between parentheses
    -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#add-spaces-between-parentheses
    local npairs   = require 'nvim-autopairs'
    local Rule     = require 'nvim-autopairs.rule'
    local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
    npairs.add_rules {
      Rule(' ', ' ')
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
    }
    for _, bracket in pairs(brackets) do
      npairs.add_rules {
        Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(function() return false end)
            :with_move(function(opts)
              return opts.prev_char:match('.%' .. bracket[2]) ~= nil
            end)
            :use_key(bracket[2])
      }
    end

    -- Expand multiple pairs on enter keys
    -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#expand-multiple-pairs-on-enter-key
    -- https://github.com/rstacruz/vim-closer/blob/master/autoload/closer.vim
    local get_closing_for_line = function(line)
      local i = -1
      local clo = ''

      while true do
        i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
        if i == nil then break end
        local ch = string.sub(line, i, i)
        local st = string.sub(clo, 1, 1)

        if ch == '{' then
          clo = '}' .. clo
        elseif ch == '}' then
          if st ~= '}' then return '' end
          clo = string.sub(clo, 2)
        elseif ch == '(' then
          clo = ')' .. clo
        elseif ch == ')' then
          if st ~= ')' then return '' end
          clo = string.sub(clo, 2)
        elseif ch == '[' then
          clo = ']' .. clo
        elseif ch == ']' then
          if st ~= ']' then return '' end
          clo = string.sub(clo, 2)
        end
      end

      return clo
    end

    npairs.remove_rule('(')
    npairs.remove_rule('{')
    npairs.remove_rule('[')

    npairs.add_rule(
      Rule("[%(%{%[]", "")
      :use_regex(true)
      :replace_endpair(function(opts)
        return get_closing_for_line(opts.line)
      end)
      :end_wise()
    )
  end
}
