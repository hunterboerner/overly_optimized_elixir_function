defmodule RustNif do
  @on_load :load

  def load do
    filename = hd(:filelib.wildcard('rust_nif/target/{debug,release}/*rust_nif*.so'))
    rootname = :filename.rootname(filename)
    :ok = :erlang.load_nif(rootname, 0)
  end

  def do_cool_stuff(a) do
    exit(:nif_library_not_loaded)
  end
end
