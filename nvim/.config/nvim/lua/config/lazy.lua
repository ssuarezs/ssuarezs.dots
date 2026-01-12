local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Cargar LazyVim Base (Importa los defaults sanos)
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- Importar tus plugins de la carpeta lua/plugins
    { import = "plugins" },
  },
  defaults = {
    -- Por defecto, LazyVim carga la última versión estable de los plugins
    version = false, -- set to false to always use the latest git commit
  },
  checker = { enabled = true }, -- Busca actualizaciones automáticamente
  performance = {
    rtp = {
      -- Desactivar plugins inútiles de vim para que cargue rápido
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})