module TourHelper
  def tour_step_li step, text
    @stepnr ||= 0
    @stepnr += 1

    current_step = @step_in_signup_process == step
    options = current_step ? {class: 'active'} : {}

    content_tag :li, options do
      content_tag(:span, @stepnr) +
      text
    end
  end

  def tour_steps
    [
      :account,
      :create_your_first_factlink,
      :install_extension,
      :interests,
      :tour_done
    ]
  end

  def first_real_tour_step
    tour_steps.drop_while {|step| step == :account}
              .first
  end

  def next_tourstep
    current_step = controller.action_name.to_sym
    current_index = tour_steps.index(current_step)
    tour_steps[current_index + 1]
  end

  def next_tourstep_path *args
    send(:"#{next_tourstep}_path", *args)
  end
end
