require 'minitest/autorun'
require 'minitest/pride'
require_relative 'dangerous_denver'

class DangerousDenverTest < MiniTest::Test

  def test_address_analysis_for_traffic_accidents
    result = compute_requested_data("./data/traffic-accidents.csv",
                                     :incident_address)
    top_accident_intersections = [["I25 HWYNB / W 6TH AVE", 532],
                                  ["I25 HWYNB / W ALAMEDA AVE", 459],
                                  ["I25 HWYSB / 20TH ST", 404],
                                  ["I70 HWYEB / N HAVANA ST", 366],
                                  ["I25 HWYSB / W ALAMEDA AVE", 360]]
    assert_equal top_accident_intersections, result
  end

  def test_neighborhood_analysis_for_traffic_accidents
    result = compute_requested_data("./data/traffic-accidents.csv",
                                     :neighborhood_id)
    top_five_accident_neighborhoods = [["stapleton", 5842],
                                      ["capitol-hill", 3647],
                                      ["five-points", 3397],
                                      ["hampden-south", 3368],
                                      ["lincoln-park", 3365]]
    assert_equal top_five_accident_neighborhoods, result
  end

  def test_neighborhood_analysis_for_non_traffic_related_crimes
    result = compute_requested_data("./data/crime.csv",
                                :neighborhood_id,
                                "traffic-accident")
    top_crime_neighborhoods = [["five-points", 14175],
                              ["cbd", 11496],
                              ["capitol-hill", 9180],
                              ["montbello", 8803],
                              ["stapleton", 8314]]
    assert_equal top_crime_neighborhoods, result
  end
end
