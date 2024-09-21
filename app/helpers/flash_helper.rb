module FlashHelper
  ALERT_KEYS = {
    'alert' => 'warning',
    'notice' => 'success',
    'error' => 'danger',
  }.freeze

  def bootstrap_alert(key)
    ALERT_KEYS[key]
  end
end
