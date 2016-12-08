class ApplicationHelper::Button::CollectLogs < ApplicationHelper::Button::Basic
  def calculate_properties
    super
    self[:prompt] = true if @record.try(:log_file_depot).try(:requires_support_case?)
  end
end
