defmodule CopyWeb.StrangeEditor do
  @moduledoc false

  use CopyWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="pb flow">
      <.simple_form for={@form} phx-change="update" phx-submit="evaluate" phx-target={@myself}>
        <h2>{@question}</h2>
        <div class="wrap-grid">
          <.input type="textarea" field={@form[:answer]} phx-debounce="750" />
          <div data-ddi-variant="brand">{@evaluation}</div>
        </div>
        <.button>Evaluate</.button>
      </.simple_form>
      <.button phx-click="inc" phx-target={@myself}>Inc</.button>
    </div>
    """
  end

  def handle_event(
        "inc",
        _params,
        socket
      ) do
    send(self(), {:inc})

    {:noreply, socket}
  end

  def handle_event(
        "evaluate",
        _,
        %{assigns: %{id: id}} = socket
      ) do
    evaluation = "Score: #{:rand.uniform(10)}"

    send(self(), {:evaluate, id, evaluation})

    {:noreply, socket}
  end

  def handle_event("update", %{"answer" => answer}, %{assigns: %{id: id}} = socket) do
    send(self(), {:updated_answer, id, answer})
    {:noreply, socket}
  end
end
