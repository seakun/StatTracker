class FieldingStatsController < ApplicationController
  def index
    @fielding_stats = FieldingStat.all
  end

  def show
    @fielding_stat = FieldingStat.find(params[:id])
  end
  
	def single_season
		@fielding_stats = FieldingStat.single_season_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , 'Team')
		@table.add_column('string' , 'Year')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		@fielding_stats.each { |b|
			i = @fielding_stats.index(b)
			@table.set_cell(i, 0, "<a href='/players/#{b.player.id}'>#{b.player.name}</a>")
			@table.set_cell(i, 1, b.player.throws)
			@table.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
			@table.set_cell(i, 3, "#{b.year}")
			@table.set_cell(i, 4, "#{b.send(params[:stat])}")
		}
		
		options = { :width => 600, :showRowNumber => true, :allowHtml=>true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end	
	end
	
	def career
		@fielding_stats = FieldingStat.career_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@fielding_stats.each { |k, v|
				@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
				@table.set_cell(i, 1, k.throws)
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

		options = { :width => 600, :showRowNumber => true, :allowHtml=>true }
		options.each_pair do | key, value |
			@table.send "#{key}=", value
		end
	end
	
	def active
		@fielding_stats = FieldingStat.active_sort(params[:stat])
		@table = GoogleVisualr::Table.new
		@table.add_column('string' , 'Name')
		@table.add_column('string' , 'Throws')
		@table.add_column('string' , params[:stat].titleize)
		@table.add_rows(50)
		i = 0
			@fielding_stats.each { |k, v|
				@table.set_cell(i, 0, "<a href='/players/#{k.id}'>#{k.name}</a>")
				@table.set_cell(i, 1, k.throws)
				@table.set_cell(i, 2, "#{v}")
				i += 1
			}

		options = { :width => 600, :showRowNumber => true, :allowHtml=>true }
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
      string = stat.downcase.gsub(" ", "_") + " " + operator + " " + number
      @stats.push(stat)
      operations.push(string)

    end
    if params[:postseason].nil?
      @batting_stats = FieldingStat.where(operations.join(" AND "))
    else
      @batting_stats = FieldingPostStat.where(operations.join(" AND "))
    end
    @chart2 = GoogleVisualr::Table.new
		@chart2.add_column('string' , 'Name')
    @chart2.add_column('string' , 'Bats')
		@chart2.add_column('string' , 'Team')
    @chart2.add_column('string' , 'Year')
    @stats.each do |i|
     @chart2.add_column('number' , i.titleize)
    end
    @chart2.add_rows(@batting_stats.size)
    @batting_stats.each { |b|
			i = @batting_stats.index(b)
			@chart2.set_cell(i, 0, "<a href='/players/#{b.player.id}'>#{b.player.name}</a>")
      @chart2.set_cell(i, 1, b.player.bats.to_s)
			@chart2.set_cell(i, 2, "<a href='/teams/#{b.team.id}'>#{b.team.name}</a>")
      @chart2.set_cell(i, 3, b.team.year.to_s)
      k=4
    @stats.each do |j|
     number= b.send(j.downcase.gsub(" ", "_"))
     @chart2.set_value(i, k, number)
     k+=1
    end
    }
    options = { :width => 600, :allowHtml=>true }
    options.each_pair do | key, value |
    @chart2.send "#{key}=", value
    @operations = operations
  end

  end
  
end
