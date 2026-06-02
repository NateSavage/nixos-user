return {
    'chrisgrieser/nvim-origami',
    event = 'BufReadPost',
    opts = {
        pauseFoldsOnSearch = true,
        foldKeymaps = {
            setup = false,
        },
        autoFold = {
            enabled = false,
        },
        foldtext = {
            enabled = true,
            lineCount = {
                template = '  %d lines',
                hlgroup = 'OrigamiFoldedLines',
            },
        },
    },
}
