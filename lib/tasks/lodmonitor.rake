task check: [:environment] do
  Host.find_each do |h|
    begin
      CheckHostJob.perform_later(h)
    rescue => e
      puts e
    end
  end
end