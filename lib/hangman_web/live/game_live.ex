defmodule HangmanWeb.GameLive do
    use HangmanWeb, :live_view

    def mount(_params, _session, socket) do  
        
        socket = assign(
            socket, 
            guess_input: "", 
            max_guesses: 10, 
            total_guesses: 0, 
            word: generate_word(), 
            guessed_letters: [],
            total_guessed_word: "",
            total_guessed_word_class: ""
        )
        socket = update(
            socket,
            :total_guessed_word,
            fn tgw -> tgw = total_guessed_word(socket) end
        )
        {:ok, socket}
    end

    def handle_event("submit", %{"guess-input" => guess_input}, socket) do
        IO.inspect(guess_input);
        guess_input = String.downcase(guess_input)
        current_total_guesses = socket.assigns.total_guesses

        socket = update(
            socket,
            :total_guesses,
            fn tg -> tg = increment_total_guesses(socket, guessed_letters(socket, guess_input)) end
        ) 
        socket = update(
            socket,
            :guessed_letters,
            fn gl -> gl = update_guessed_letters(socket, guessed_letters(socket, guess_input)) end
        )
        socket = update(
            socket,
            :total_guessed_word,
            fn tgw -> tgw = total_guessed_word(socket) end
        )
        socket = update(
            socket,
            :total_guessed_word_class,
            fn tgwc -> tgwc = 
                if current_total_guesses == socket.assigns.total_guesses or 
                 List.to_string(socket.assigns.word) == socket.assigns.total_guessed_word, 
                    do: "success", else: "error" 
            end
        )
        
        {:noreply, socket}
    end
    

    defp generate_word() do Dictionary.random_word() |> String.codepoints() end

    defp increment_total_guesses(socket, guessed_letters) do
        if Enum.sort(guessed_letters) == Enum.sort(socket.assigns.guessed_letters) do
            socket.assigns.total_guesses + 1
        else
            socket.assigns.total_guesses 
        end
    end

    defp update_guessed_letters(socket, guessed_letters) do
        if Enum.sort(guessed_letters) == Enum.sort(socket.assigns.guessed_letters) do
            socket.assigns.guessed_letters
        else
            guessed_letters
        end
    end
    

    defp guessed_letters(socket, guess) do
        (socket.assigns.guessed_letters ++ match_guessed_letter(socket, guess))
        |> Enum.uniq()
    end

    defp match_guessed_letter(socket, guess) do
        Enum.map(socket.assigns.word, fn letter ->
            if guess == letter, do: letter
        end)
        |> Enum.filter(&(!is_nil(&1)))
    end

    defp total_guessed_word(socket) do
        Enum.map(socket.assigns.word, fn letter ->
          if Enum.member?(socket.assigns.guessed_letters, letter), do: letter, else: "_"
        end)
        |> List.to_string()
    end

end