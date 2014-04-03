class CallbackWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(psychic_id)
    psychic = Psychic.find(psychic_id)

    Rails.logger.info "[CallbackWorker] Initiating callback check for #{psychic.full_name}"
    callback = psychic.callbacks.next.first

    Rails.logger.info "[CallbackWorker] Next callback: #{callback.inspect}"
    return unless callback

    Rails.logger.info "[CallbackWorker] Calling psychic"
    callback.execute
  end
end
