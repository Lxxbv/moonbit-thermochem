///|
fn main {
  match @env.args() {
    [_, .. args] => println(@thermochem_cli.render(args.to_owned()))
    _ => println(@thermochem_cli.help_text())
  }
}
