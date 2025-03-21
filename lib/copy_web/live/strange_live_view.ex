defmodule CopyWeb.StrangeViewLive do
  @moduledoc false

  use CopyWeb, :live_view
  alias CopyWeb.StrangeEditor

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        questionnaire: [
          %{id: "color", question: "favourite color?", form: to_form(%{"answer" => ""})},
          %{id: "food", question: "favourite food?", form: to_form(%{"answer" => ""})},
          %{id: "animal", question: "favourite animal?", form: to_form(%{"answer" => ""})}
        ],
        answers: %{},
        evaluations: %{},
        counter: 0
      )

    {:ok, socket}
  end

  def handle_info({:inc}, socket) do
    counter = Map.get(socket.assigns, :counter, 0)
    {:noreply, assign(socket, counter: counter + 1)}
  end

  def handle_info({:evaluate, question_id, evaluation}, socket) do
    counter = Map.get(socket.assigns, :counter, 0)

    socket =
      assign(socket,
        evaluations: Map.put(socket.assigns.evaluations, question_id, evaluation),
        counter: counter + 1
      )

    {:noreply, socket}
  end

  def handle_info({:updated_answer, question_id, answer}, socket) do
    counter = Map.get(socket.assigns, :counter, 0)

    {:noreply,
     assign(socket,
       answers: Map.put(socket.assigns.answers, question_id, answer),
       counter: counter + 1
     )}
  end

  def render(assigns) do
    ~H"""
    <main class="p" data-ddi-variant="normal">
      <div>counter: {@counter}</div>
      <.live_component
        :for={item <- @questionnaire}
        module={StrangeEditor}
        id={item.id}
        question={item.question}
        answer={Map.get(@answers, item.id, "")}
        form={item.form}
        evaluation={Map.get(@evaluations, item.id, "")}
      />
    </main>
    """
  end
end
