require 'csv'
require 'pry'
require 'benchmark'

def compute_requested_data(file_path, attribute, filter = nil)
  data = parse_csv_data(file_path, filter)
  analyze_crime_data(data, attribute)
end

def parse_csv_data(file_path, filter = nil)
  @data = []
  CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
    @data << row.to_h
  end
  check_filter(filter)
end

def check_filter(filter = nil)
  if filter
    @data = @data.reject do |incident|
      incident[:offense_category_id] == filter
    end
  end
  @data
end

def group_crime_data(data, attribute)
  @grouped = data.group_by do |incident|
    incident[attribute]
  end
  filter_keys

    @grouped.map do |key, incidents|
      [key, incidents.count]
  end
end

def filter_keys
  @grouped.shift
end

def analyze_crime_data(data, attribute)
  group_crime_data(data, attribute).sort_by do |incident_count|
    -incident_count[1]
  end[0..4]
end

if __FILE__ == $0
  Benchmark.bm do |task|
    task.report { result = analyze("./data/traffic-accidents.csv",
                                     :incident_address)
                 puts result
                }
  end
  Benchmark.bm do |task|
   task.report { result = analyze("./data/traffic-accidents.csv",
                                    :incident_address)
                puts result
               }
  end
  Benchmark.bm do |task|
    task.report { result = analyze("./data/crime.csv",
                                     :neighborhood_id,
                                     "traffic-accident")
                 puts result
                }
  end
end
