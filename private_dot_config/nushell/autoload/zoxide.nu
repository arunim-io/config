try {
  zoxide init nushell | save -f ($nu.data-dir | path join vendor autoload zoxide.nu)
}
