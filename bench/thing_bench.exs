:random.seed(:os.timestamp)

defmodule ThingBench do
  use Benchfella

  @l Enum.to_list(1..100)
  @q (@l ++ @l ++ @l ++ @l ++ @l)
  @list Enum.take_random(@q, 200)

  bench "kirillv" do
    kirillv
  end

  bench "henrik single-iteration (broken...)" do
    henrik_single
  end

  bench "henrik second attempt (all occurrences of largest #)" do
    henrik_second
  end

  bench "true_droid single-iteration (all occurrences of largest #)" do
    true_droid_single
  end

  bench "true_droid single-iteration erl :lists (all occurrences of largest #)" do
    true_droid_single_erl_lists
  end

  bench "true_droid custom reduce" do
    true_droid_custom_reduce
  end

  bench "simple, but stupid... wow, not actually that bad. I'm surprised." do
    simple
  end

  bench "my first attempt" do
    my_first_attempt
  end

  bench "my second attempt" do
    my_first_attempt
  end

  bench "my second attempt using Enum.filter" do
    my_first_attempt
  end

  bench "count it" do
    my_first_attempt
  end

  bench "Rust NIF" do
    rust_nif
  end

  def rust_nif do
    RustNif.do_cool_stuff(@list)
  end


  def my_second_attempt do
    max = :lists.max(@list)
    :lists.filter(&(&1 == max), @list)
  end

  def count_it do
    max = :lists.max(@list)
    occur = count(max, @list)
    List.duplicate(max, occur)
  end

  defp count(needle, haystack), do: count(needle, haystack, 0)
  defp count(_, [], count), do: count
  defp count(x, [x|rest], count), do: count(x, rest, count + 1)
  defp count(x, [_|rest], count), do: count(x, rest, count)

  def my_second_attempt_enum do
    max = :lists.max(@list)
    Enum.filter @list, &(&1 == max)
  end

  def simple do
    max = Enum.max(@list)
    Enum.filter @list, &(&1 == max)
  end

  def true_droid_single_erl_lists do
    :lists.foldl(fn
      item, [] -> [item]
      item, [curmax|_] when item > curmax -> [item]
      curmax, [curmax|_]=acc -> [curmax|acc]
      _, acc -> acc
    end, [], @list)
  end

  def true_droid_single do
    Enum.reduce(@list, [], fn
      item, [] -> [item]
      item, [curmax|_] when item > curmax -> [item]
      curmax, [curmax|_]=acc -> [curmax|acc]
      _, acc -> acc
    end)
  end

  def true_droid_custom_reduce do
    custom_reduce(@list, [])
  end

  def custom_reduce([],    acc), do: acc
  def custom_reduce([h|t], []), do: custom_reduce(t, [h])
  def custom_reduce([h|t], [curmax|_]) when h > curmax, do: custom_reduce(t, [h])
  def custom_reduce([h|t], [h|_] = acc), do: custom_reduce(t, [h|acc])
  def custom_reduce([_|t], acc), do: custom_reduce(t, acc)

  def my_first_attempt do
    {max, occur} = Enum.reduce(@list, nil, fn
      item, nil -> {item, 1}
      item, {curmax, _} when item > curmax -> {item, 1}
      curmax, {curmax, occur} -> {curmax, occur + 1}
      _, acc -> acc
    end)
    List.duplicate(max, occur)
  end

  def henrik_second do
    Enum.reduce(@list, {Enum.at(@list, 0), []}, fn (item, {item, out}) -> {item, [item|out]}; (item, {max, out}) when max < item -> {item, [item]}; (_item, acc) -> acc end) |> elem(1)
  end

  # Dunno what this is supposed to do...
  def henrik_single do
    Enum.reduce(@list, {0, []}, fn(item, {curmax, out}) -> {max(curmax, item), (item > curmax && [item] || [item|out]) } end) |> elem(1)
  end

  def kirillv do
    @list |> Enum.sort |> Enum.reverse |> Enum.chunk_by(fn i -> i end)
  end
end

IO.inspect ThingBench.true_droid_single
IO.inspect ThingBench.henrik_second
IO.inspect ThingBench.henrik_single
IO.inspect ThingBench.simple
IO.inspect ThingBench.my_first_attempt
IO.inspect ThingBench.count_it
IO.inspect ThingBench.true_droid_custom_reduce
IO.inspect ThingBench.rust_nif
