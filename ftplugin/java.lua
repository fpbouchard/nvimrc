local HOME = os.getenv("HOME")
local JABBA_HOME = os.getenv("JABBA_HOME")
local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

vim.pretty_print("ROOT DIR: " .. root_dir)

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = HOME .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local jdtls_root = vim.fn.glob(HOME .. "/.local/share/jdtls")

local on_attach = require("../lsp_config").on_attach

local config = {
	on_attach = on_attach,
	cmd = {
		JABBA_HOME .. "/jdk/default/Contents/Home/bin/java", -- or '/path/to/java17_or_newer/bin/java'
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
		"-javaagent:" .. HOME .. "/.local/share/eclipse/lombok.jar",
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
			configuration = {
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = JABBA_HOME .. "/jdk/zulu@1.8/Contents/Home",
					},
				},
			},
		},
	},
}

require("jdtls").start_or_attach(config)
