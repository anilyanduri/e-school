module ApplicationHelper

  def enroll_icon
    icon_from_string('enroll')
  end

  def enrolled_icon
    icon_from_string('enrolled')
  end

  def enrolled_icon
    icon_from_string('pending')
  end

  def icon_from_string(string, color=nil)
    if color
      string.split("").collect { |c| "<i class='fa-solid fa-#{c} fa-2xs' style='color: #{color};'></i>" }.join('')
    else
      string.split("").collect { |c| "<i class='fa-solid fa-#{c} fa-2xs'></i>" }.join()
    end
  end
end
