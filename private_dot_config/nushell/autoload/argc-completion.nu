let root_dir = $nu.data-dir | path dirname | path join argc-completions

if not ($root_dir | path exists) {
  print "argc-completion git repo not found. Cloning the repo now..."
  ^git clone "https://github.com/sigoden/argc-completions.git" $root_dir
}

let scripts_dir = $root_dir | path join scripts
let bin_path = $root_dir | path join bin

if not ($bin_path | path exists) {
  print "Downloading neccessary tools..."
  ^bash ($scripts_dir | path join download-tools.sh)
}

$env.ARGC_COMPLETIONS_PATH = ($root_dir + '/completions/linux:' + $root_dir + '/completions')
$env.path ++= [$bin_path]

argc --argc-completions nushell | save -f ($nu.data-dir | path join vendor autoload argc.nu)
