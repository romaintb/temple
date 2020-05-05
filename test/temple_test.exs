defmodule TempleTest do
  use ExUnit.Case, async: true
  use Temple
  use Temple.Support.Utils

  test "renders an attribute on a div passed as a variable" do
    result =
      temple do
        div class: "hello" do
          div class: "hi"
        end
      end

    assert result == ~s{<div class="hello"><div class="hi"></div></div>}
  end

  test "renders void element" do
    result =
      temple do
        input name: "password"
      end

    assert result == ~s{<input name="password">}
  end

  test "renders a text node from the text keyword with siblings" do
    result =
      temple do
        div class: "hello" do
          "hi"
          "foo"
        end
      end

    assert result == ~s{<div class="hello">hifoo</div>}
  end

  test "renders a variable text node as eex" do
    result =
      temple do
        div class: "hello" do
          foo
        end
      end

    assert result == ~s{<div class="hello"><%= foo %></div>}
  end

  test "renders an assign text node as eex" do
    result =
      temple do
        div class: "hello" do
          @foo
        end
      end

    assert result == ~s{<div class="hello"><%= @foo %></div>}
  end

  test "renders a match expression" do
    result =
      temple do
        x = 420

        div do
          "blaze it"
        end
      end

    assert result == ~s{<% x = 420 %><div>blaze it</div>}
  end

  test "renders a non-match expression" do
    result =
      temple do
        IO.inspect(:foo)

        div do
          "bar"
        end
      end

    assert result == ~s{<%= IO.inspect(:foo) %><div>bar</div>}
  end

  test "renders an expression in attr as eex" do
    result =
      temple do
        div class: foo <> " bar"
      end

    assert result == ~s{<div class="<%= foo <> " bar" %>"></div>}
  end

  test "renders an attribute on a div passed as a variable as eex" do
    result =
      temple do
        div class: Enum.map([:one, :two], fn x -> x end) do
          div class: "hi"
        end
      end

    assert result ==
             ~s{<div class="<%= Enum.map([:one, :two], fn x -> x end) %>"><div class="hi"></div></div>}
  end

  test "renders a for comprehension as eex" do
    result =
      temple do
        for x <- 1..5 do
          div class: "hi"
        end
      end

    assert result == ~s{<%= for(x <- 1..5) do %><div class="hi"></div><% end %>}
  end

  test "renders an if expression as eex" do
    result =
      temple do
        if true == false do
          div class: "hi"
        end
      end

    assert result == ~s{<%= if(true == false) do %><div class="hi"></div><% end %>}
  end

  test "renders an if/else expression as eex" do
    result =
      temple do
        if true == false do
          div class: "hi"
        else
          div class: "haha"
        end
      end

    assert result ==
             ~s{<%= if(true == false) do %><div class="hi"></div><% else %><div class="haha"></div><% end %>}
  end

  test "renders an unless expression as eex" do
    result =
      temple do
        unless true == false do
          div class: "hi"
        end
      end

    assert result == ~s{<%= unless(true == false) do %><div class="hi"></div><% end %>}
  end

  test "renders multiline anonymous functions" do
    result =
      temple do
        form_for @changeset, Routes.user_path(@conn, :create), fn f ->
          "Name: "
          text_input f, :name
        end
      end

    assert result == ~s{<%= form_for(@changeset, Routes.user_path(@conn, :create), fn f -> %>Name: <%= text_input f, :name %><% end %>}
  end
  test "hell this " do
    IO.inspects "poop", label: "The poop"
    Io.inspects "poop", label: "The pooop"
  end
  ast = {:form_for, [], [
   {:@, [line: 157], [{:changeset, [line: 157], nil}]},
   {{:., [line: 157], [{:__aliases__, [line: 157], [:Routes]}, :user_path]},
    [line: 157], [{:@, [line: 157], [{:conn, [line: 157], nil}]}, :create]},
   {:fn, [line: 157],
    [
      {:->, [line: 157],
       [
         [{:f, [line: 157], nil}]
       ]}
    ]}
 ]}
end
