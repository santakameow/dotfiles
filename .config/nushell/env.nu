# env.nu

$env.PATH = ($env.PATH | append ($env.HOME | path join ".opencode/bin"))
