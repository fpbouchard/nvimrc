local function get_asdf_java_versions()
  local handle = io.popen("ls -1 ~/.asdf/installs/java")
  local result = handle:read("*a")
  handle:close()
  local versions = {}
  for line in result:gmatch("[^\r\n]+") do
    -- Adjusted pattern to match both old and new versioning schemes
    local name, version = line:match("^(%w+)%-(%d+[%d%.]*)$")
    if name and version then
      local major_version = version:match("^(%d+)")
      if major_version then
        table.insert(versions, {
          name = "JavaSE-" .. major_version,
          path = "/Users/fp/.asdf/installs/java/" .. line,
        })
      end
    end
  end
  return versions
end

local function find_java_version(runtimes, version_name)
  for _, runtime in ipairs(runtimes) do
    if runtime.name == version_name then
      return runtime
    end
  end
  return nil -- Return nil if the version is not found
end

return {
  "mfussenegger/nvim-jdtls",
  dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
  config = function()
    local augroup = vim.api.nvim_create_augroup("jdtls", {})
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      group = augroup,
      callback = function()
        local HOME = os.getenv("HOME")
        -- local JAVA_HOME = os.getenv("JAVA_HOME")
        local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
        local root_dir = require("jdtls.setup").find_root(root_markers)

        -- eclipse.jdt.ls stores project specific data within a folder. If you are working
        -- with multiple different projects, each project must use a dedicated data directory.
        -- This variable is used to configure eclipse to use the directory name of the
        -- current project found using the root_marker as the folder for project specific data.
        local workspace_folder = HOME .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

        local mason_path = require("mason-core.path")
        local function get_install_path(package)
          return require("mason-registry").get_package(package):get_install_path()
        end

        local jdtls_root = mason_path.concat({ get_install_path("jdtls") })

        -- dynamically build the runtimes based on the asdf-installed java versions
        local runtimes = get_asdf_java_versions()

        -- Find a JavaSE-17 runtime in the runtimes table
        local jdtls_runtime = find_java_version(runtimes, "JavaSE-17")
        if jdtls_runtime == nil then
          print("JavaSE-17 not found in asdf-installed java versions")
          return
        end
        local jdtls_runtime_path = jdtls_runtime.path .. "/bin/java"

        local config = {
          cmd = {
            jdtls_runtime_path,
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx4g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-javaagent:" .. HOME .. "/.local/share/eclipse/lombok.jar", -- Lombok required in some projects
            "-jar",
            vim.fn.glob(jdtls_root .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
            "-configuration",
            jdtls_root .. "/config_mac",
            "-data",
            workspace_folder,
          },
          root_dir = root_dir,
          settings = {
            java = {
              format = {
                enabled = false, -- using google-java-format through null-ls
              },
              configuration = {
                runtimes = runtimes, -- dynamically built runtimes
              },
            },
          },
        }

        require("jdtls").start_or_attach(config)
      end,
    })
  end,
}
