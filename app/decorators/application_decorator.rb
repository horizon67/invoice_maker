class ApplicationDecorator < Draper::Decorator
  delegate_all

  def created_at
    if object.created_at.present?
      object.created_at.strftime("%Y-%m-%d %H:%M:%S")
    end
  end

  def updated_at
    if object.updated_at.present?
      object.updated_at.strftime("%Y-%m-%d %H:%M:%S")
    end
  end

  def created_date
    if object.created_at.present?
      object.created_at.strftime("%Y年%_m月%e日")
    end
  end

  def created_datetime
    if object.created_at.present?
      object.created_at.strftime("%Y年%_m月%e日 %H時%M分")
    end
  end

  def updated_datetime
    if object.updated_at.present?
      object.updated_at.strftime("%Y年%_m月%e日 %H時%M分")
    end
  end

  def created_month_day
    if object.created_at.present?
      object.created_at.strftime("%_m月%e日")
    end
  end

  def updated_date
    if object.updated_at.present?
      object.updated_at.strftime("%Y年%_m月%e日")
    end
  end

  def created_timestamp
    if object.created_at.present?
      object.created_at.to_i
    end
  end

  def updated_timestamp
    if object.updated_at.present?
      object.updated_at.to_i
    end
  end

  def error_message_for(attribute)
    return (object.errors.get(attribute) || []).map { |message| object.errors.full_message(attribute, message) }
  end

  def errors?(attribute)
    object.errors.include?(attribute)
  end

  def self.build_absolute_url(relative_url)
    "#{ApplicationSettings.service_domain_prefix}#{ApplicationSettings.service_domain}#{relative_url.to_s}"
  end

  def build_absolute_url(relative_url)
    ApplicationDecorator.build_absolute_url(relative_url)
  end

  # 改行を表示する
  def br(attribute=:text)
    text = object.send(attribute)

    if text.present?
      text = h.h text
      text.gsub(/\r\n|\r|\n/, "<br />").html_safe
    else
      text
    end
  end
end
