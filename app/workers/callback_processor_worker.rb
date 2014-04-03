class CallbackProcessorWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(callback_id, call_sid)
    callback = Callback.find(callback_id)
    callback.finish(call_sid)
  end
end
