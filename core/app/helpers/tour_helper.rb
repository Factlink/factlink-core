module TourHelper
  def show_active_step step_in_signup_proces, step
    if step_in_signup_proces == step
      ' class="active"'.html_safe
    end
  end

  def tour_steps
    [
      :create_your_first_factlink,
      :install_extension,
      :choose_channels
    ]
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
