return {
    {"nvim-treesitter/nvim-treesitter"},
    {"neovim/nvim-lspconfig"},
	{"kien/ctrlp.vim"},
	{"averms/black-nvim"},
	{"jpalardy/vim-slime"},
	{"vim-test/vim-test"},
    {"github/copilot.vim"},
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
	{
		"AstroNvim/astrotheme",
		config = true,
	},
    {'loctvl842/monokai-pro.nvim'},
    {'NLKNguyen/papercolor-theme'},
    {'ellisonleao/gruvbox.nvim'},
    {'sainnhe/gruvbox-material'},
    {
        'crispgm/nvim-tabline',
        dependencies = { 'nvim-tree/nvim-web-devicons' }, -- optional
        config = true,
    },
    {"rebelot/heirline.nvim"},
    {"tpope/vim-surround"},
    {"lervag/vimtex"},
    {'jmbuhr/otter.nvim'},
    {'quarto-dev/quarto-nvim'},
    {"JuliaEditorSupport/julia-vim"},
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
        end,
    },
    {'hrsh7th/nvim-cmp'},
    -- install without yarn or npm
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    }
}
