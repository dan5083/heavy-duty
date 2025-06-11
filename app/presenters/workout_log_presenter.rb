class WorkoutLogPresenter
  attr_reader :log

  def initialize(log)
    @log = log
  end

  def summary
    log.details.presence || "—"
  end

  def date
    log.created_at.strftime("%b %d, %Y")
  end

  def notes
    log.details.presence || "—"
  end
end
