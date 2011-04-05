class BattingPostStatsController < ApplicationController
  def index
    @batting_post_stats = BattingPostStat.all
  end

  def show
    @batting_post_stat = BattingPostStat.find(params[:id])
  end  
	def single_season
		@batting_post_stats = BattingPostStat.single_season_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'Year')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		@batting_post_stats.each { |b|
			i = @batting_post_stats.index(b)
			@table.set_cell(i, 0, "<a href='/teams/#{b.player.id}'>#{b.player.name}</a>")
			@table.set_cell(i, 1, b.player.bats)
			@table.set_cell(i, 2,"<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
			@table.set_cell(i, 3, "#{b.year}")
			@table.set_cell(i, 4, "#{b.send(params[:stat])}")
		}
		
		options = { :width => 600, :showRowNumber => true, :allowHtml =>true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
  
	def career
		@batting_post_stats = BattingPostStat.career_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@batting_post_stats.each { |k, v|
				@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
				@table.set_cell(i, 1, k.bats)
				@table.set_cell(i, 2, "#{v}")
				i = i + 1
			}

		options = { :width => 600, :showRowNumber => true, :allowHtml =>true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def active
		@batting_post_stats = BattingPostStat.active_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Bats')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@batting_post_stats.each { |k, v|
				@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
				@table.set_cell(i, 1, k.bats)
				@table.set_cell(i, 2, "#{v}")
				i = i + 1
			}

		options = { :width => 600, :showRowNumber => true, :allowHtml =>true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end

  def season_finder

  end

  def find_seasons
    number = params[:fields][:count].to_i
    @stats = []
    operations = []
    (1..number).each do |i|
      stat = params["#{i}"][:stat]
      next if stat.blank?
      operator = params["#{i}"][:operator]
      number = params["#{i}"][:number]
      string = stat + " " + operator + " " + number
      @stats.push(stat)
      operations.push(string)
    end
    @batting_stats = BattingPostStat.where(operations.join(" AND "))

  end
	
end
