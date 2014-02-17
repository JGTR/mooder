class DataPointProvider

  def initialize(target)
    @target = target
    # @mood_metric_id = mm_id
    @min_id = 0
    @pages = 0
    @analyzer = Sentimental.new
  end

  def search_pages
    while @pages < 100
      search
    end
  end

  def search
    if @min_id == 0
      results = $client.search(@target)
    else
      results = $client.search(@target, :max_id => @min_id)
    end
    @pages += 1
    create_data(results)
  end


  def create_data(results)
    count = 0
    results.attrs[:statuses].each do |status|
      attributes = {}
      attributes[:text] = status[:text]
      attributes[:tweet_id] = status[:id] 
      attributes[:time_posted] = status[:created_at]
      attributes[:twitter_user_name] = status[:user][:name]
      attributes[:twitter_user_id] = status[:user][:id]
      attributes[:target] = @target
      attributes[:sentiment_score] = @analyzer.get_score(status[:text])

      datapoint = DataPoint.find_or_initialize_by(:tweet_id => attributes[:tweet_id])

      datapoint.attributes = attributes

      if datapoint.new_record?
        puts "FETCHED"
        datapoint.save
      else
        datapoint.save
      end

      # datapoint.mood_metric_id = @mood_metric_id

      count += 1

      puts count

      puts "="*80

      if @min_id == 0
        @min_id = attributes[:tweet_id]
      elsif @min_id > attributes[:tweet_id]
        @min_id = attributes[:tweet_id]
      end
    end

  end


end

# rails g migration CreateDataPoints text:string tweet_id:integer time_posted:string twitter_user_name:string twitter_user_id:integer target:string