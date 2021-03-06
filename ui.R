## ui.R ##
shinyUI(dashboardPage(skin = 'purple',
  dashboardHeader(title = 'Car Accidents in NYC'),
  dashboardSidebar(
    #sidebarUserPanel('',image = 'https://i.ytimg.com/vi/QZglt2rnX0Y/hqdefault.jpg'),
    sidebarMenu(id = 'sideBarMenu',
      
      menuItem("Accidents", tabName = "plot", icon = icon("bar-chart-o"),
      menuSubItem("2013 - 2016 Trend", tabName = "trend",icon = icon("line-chart")),
      menuSubItem("By Year and Borough", tabName = "plot",icon = icon("bar-chart-o")),
      menuSubItem("By Weekdays", tabName = "plot2",icon = icon("bar-chart-o"))),
      
      menuItem("Heat Map of Accidents", tabName = "map1", icon = icon("map")),
      
      menuItem("Map of Fatalities", tabName = "map2", icon = icon("map")),
      
      menuItem("By Neighborhood", tabName = "table", icon = icon("database")),
      
      menuItem("Highest Injury Ratio?", tabName = "injratio", icon = icon("bar-chart-o"),
      menuSubItem("Injury/Death to Accidents", tabName = "injratio",icon = icon("bar-chart-o")),
      menuSubItem("Cause of Accidents", tabName = "motorcycles",icon = icon("database")),
      menuSubItem("Map by Causes", tabName = "motoraccidents",icon = icon("map"))
      )
      
      # menuItem('Future Features', tabName = 'future', icon = icon('exclamation-triangle'))
      ),
      
    
    conditionalPanel("input.sideBarMenu == 'trend'",
                     selectizeInput('vehicle3',
                                    'VEHICLE TYPE',
                                    choice = c('All' = 'VEHICLE.TYPE.CODE.1 != "ALL"',
                                               'TAXI' = 'VEHICLE.TYPE.CODE.1 == "TAXI"',
                                               'LIVERY VEHICLE' = 'VEHICLE.TYPE.CODE.1 == "LIVERY VEHICLE"',
                                               'SCOOTER' = 'VEHICLE.TYPE.CODE.1 == "SCOOTER"',
                                               'OTHER' = 'VEHICLE.TYPE.CODE.1 == "OTHER"',
                                               'MOTORCYCLE' = 'VEHICLE.TYPE.CODE.1 == "MOTORCYCLE"',
                                               'AMBULANCE' = 'VEHICLE.TYPE.CODE.1 == "AMBULANCE"',
                                               'PICK-UP TRUCK' = 'VEHICLE.TYPE.CODE.1 == "PICK-UP TRUCK"',
                                               'UNKNOWN' = 'VEHICLE.TYPE.CODE.1 == "UNKNOWN"',
                                               'BUS' = 'VEHICLE.TYPE.CODE.1 == "BUS"',
                                               'FIRE TRUCK' = 'VEHICLE.TYPE.CODE.1 == "FIRE TRUCK"',
                                               'UTL/STN WGN' = 'VEHICLE.TYPE.CODE.1 == "SPORT UTILITY / STATION WAGON"',
                                               'VAN' = 'VEHICLE.TYPE.CODE.1 == "VAN"',
                                               'NA' = 'VEHICLE.TYPE.CODE.1 == ""',
                                               'SMALL COM VEH' = 'VEHICLE.TYPE.CODE.1 == "SMALL COM VEH(4 TIRES)"',
                                               'BIKE' = 'VEHICLE.TYPE.CODE.1 == "BICYCLE"',
                                               'LARGE COM VEH' = 'VEHICLE.TYPE.CODE.1 == "LARGE COM VEH(6 OR MORE TIRES)"',
                                               'PEDICAB' = 'VEHICLE.TYPE.CODE.1 == "PEDICAB"'
                                    ))
                     
                     
    ),
    
    
      conditionalPanel("input.sideBarMenu == 'map1'",
                       selectizeInput('borough',
                                      'BOROUGH',
                                      choice = c('All' = 'BOROUGH != ""',
                                                 'Brooklyn' = 'BOROUGH == "BROOKLYN"',
                                                 'Bronx' = 'BOROUGH == "BRONX"',
                                                 'Queens' = 'BOROUGH == "QUEENS"',
                                                 'Staten Island' = 'BOROUGH == "STATEN ISLAND"',
                                                 'Manhattan' = 'BOROUGH == "MANHATTAN"')),
                       
                       
                       selectizeInput('vehicle',
                                      'VEHICLE TYPE',
                                      choice = c('All' = 'VEHICLE.TYPE.CODE.1 != "ALL"',
                                                 'TAXI' = 'VEHICLE.TYPE.CODE.1 == "TAXI"',
                                                 'LIVERY VEHICLE' = 'VEHICLE.TYPE.CODE.1 == "LIVERY VEHICLE"',
                                                 'SCOOTER' = 'VEHICLE.TYPE.CODE.1 == "SCOOTER"',
                                                 'OTHER' = 'VEHICLE.TYPE.CODE.1 == "OTHER"',
                                                 'MOTORCYCLE' = 'VEHICLE.TYPE.CODE.1 == "MOTORCYCLE"',
                                                 'AMBULANCE' = 'VEHICLE.TYPE.CODE.1 == "AMBULANCE"',
                                                 'PICK-UP TRUCK' = 'VEHICLE.TYPE.CODE.1 == "PICK-UP TRUCK"',
                                                 'UNKNOWN' = 'VEHICLE.TYPE.CODE.1 == "UNKNOWN"',
                                                 'BUS' = 'VEHICLE.TYPE.CODE.1 == "BUS"',
                                                 'FIRE TRUCK' = 'VEHICLE.TYPE.CODE.1 == "FIRE TRUCK"',
                                                 'UTL/STN WGN' = 'VEHICLE.TYPE.CODE.1 == "SPORT UTILITY / STATION WAGON"',
                                                 'VAN' = 'VEHICLE.TYPE.CODE.1 == "VAN"',
                                                 'NA' = 'VEHICLE.TYPE.CODE.1 == ""',
                                                 'SMALL COM VEH' = 'VEHICLE.TYPE.CODE.1 == "SMALL COM VEH(4 TIRES)"',
                                                 'BIKE' = 'VEHICLE.TYPE.CODE.1 == "BICYCLE"',
                                                 'LARGE COM VEH' = 'VEHICLE.TYPE.CODE.1 == "LARGE COM VEH(6 OR MORE TIRES)"',
                                                 'PEDICAB' = 'VEHICLE.TYPE.CODE.1 == "PEDICAB"'
                                      )),
                       
                       sliderInput('heatslide', label = 'Set size of radius (in meters): ', 
                                   min = 0, max = 2000, value = 200, step = 100),
                       dateRangeInput('dateRange',
                                      label = 'Date range input: yyyy-mm-dd',
                                      start = '2013-01-01', end = '2016-12-31', 
                                      min = '2013-01-01', max = '2016-12-31'),
                       
                       radioButtons("time1", "Select time: ",
                                    c('All' = "TIME >= 00:00:00 & TIME <= 06:00:00",
                                      "12:00 am - 6:00 am" = "TIME >= '00:00:00' & TIME <= '06:00:00'",
                                      "6:00 am - 12:00 pm" = "TIME >= '06:00:00' & TIME <= '12:00:00'",
                                      "12:00 pm - 6:00 pm" = "TIME >= '12:00:00' & TIME <= '18:00:00'",
                                      "6:00 pm - 12:00 am" = "TIME >= '18:00:00' & TIME <= '23:59:59'")),
                       
                       selectizeInput('filter',
                                      'Number of Vehicles Involved: ',
                                      choice = c('All' = 'no.of.cars !=""',
                                                 '1' = 'no.of.cars == 1',
                                                 '2' = 'no.of.cars == 2',
                                                 '3' = 'no.of.cars == 3',
                                                 '4' = 'no.of.cars == 4',
                                                 '5' = 'no.of.cars == 5',
                                                 '2+' = 'no.of.cars > 1',
                                                 '3+' = 'no.of.cars > 2'))
                       
                       
      ),
      conditionalPanel("input.sideBarMenu == 'map2'",
                       selectizeInput('borough1',
                                      'BOROUGH',
                                      choice = c('All' = 'BOROUGH != ""',
                                                 'Brooklyn' = 'BOROUGH == "BROOKLYN"',
                                                 'Bronx' = 'BOROUGH == "BRONX"',
                                                 'Queens' = 'BOROUGH == "QUEENS"',
                                                 'Staten Island' = 'BOROUGH == "STATEN ISLAND"',
                                                 'Manhattan' = 'BOROUGH == "MANHATTAN"')),
                       
                       checkboxGroupInput('show_vars', 'Select group: ',
                                          c('Pedestrians - Red' = 'NUMBER.OF.PEDESTRIANS.KILLED > 0',
                                            'Cyclists - Green' = 'NUMBER.OF.CYCLIST.KILLED > 0',
                                            'Motorists - Blue' = 'NUMBER.OF.MOTORIST.KILLED > 0')),
                       #                    selected = c('NUMBER.OF.PEDESTRIANS.KILLED > 0',
                       #                                 'NUMBER.OF.CYCLIST.KILLED > 0',
                       #                                 'NUMBER.OF.MOTORIST.KILLED > 0')),
                       
                       sliderInput('circlesize', label = 'Circle size :', 
                                   min = 10, max = 500, value = 200, step = 50),
                       
                       dateRangeInput('dateRange2',
                                      label = 'Date range input: yyyy-mm-dd',
                                      start = '2013-01-01', end = '2016-12-31',
                                      min = '2013-01-01', max = '2016-12-31'),
                       
                       radioButtons("time2", "Select time: ",
                                    c('All' = "TIME >= 00:00:00 & TIME <= 06:00:00",
                                      "12:00 am - 6:00 am" = "TIME >= '00:00:00' & TIME <= '06:00:00'",
                                      "6:00 am - 12:00 pm" = "TIME >= '06:00:00' & TIME <= '12:00:00'",
                                      "12:00 pm - 6:00 pm" = "TIME >= '12:00:00' & TIME <= '18:00:00'",
                                      "6:00 pm - 12:00 am" = "TIME >= '18:00:00' & TIME <= '23:59:59'"))
      ),
      conditionalPanel("input.sideBarMenu == 'plot'",
                       selectizeInput('plot',
                                      'Accidents by casualties: ',
                                      choice = c('All' = "NUMBER.OF.PERSONS.KILLED != ''",
                                                 'Injured or Killed' = 'NUMBER.OF.PERSONS.KILLED != 0 | NUMBER.OF.PERSONS.INJURED !=0',
                                                 'Unharmed' = 'NUMBER.OF.PERSONS.KILLED == 0 & NUMBER.OF.PERSONS.INJURED ==0')),
                       
                       selectizeInput('vehicle4',
                                      'VEHICLE TYPE',
                                      choice = c('All' = 'VEHICLE.TYPE.CODE.1 != "ALL"',
                                                 'TAXI' = 'VEHICLE.TYPE.CODE.1 == "TAXI"',
                                                 'LIVERY VEHICLE' = 'VEHICLE.TYPE.CODE.1 == "LIVERY VEHICLE"',
                                                 'SCOOTER' = 'VEHICLE.TYPE.CODE.1 == "SCOOTER"',
                                                 'OTHER' = 'VEHICLE.TYPE.CODE.1 == "OTHER"',
                                                 'MOTORCYCLE' = 'VEHICLE.TYPE.CODE.1 == "MOTORCYCLE"',
                                                 'AMBULANCE' = 'VEHICLE.TYPE.CODE.1 == "AMBULANCE"',
                                                 'PICK-UP TRUCK' = 'VEHICLE.TYPE.CODE.1 == "PICK-UP TRUCK"',
                                                 'UNKNOWN' = 'VEHICLE.TYPE.CODE.1 == "UNKNOWN"',
                                                 'BUS' = 'VEHICLE.TYPE.CODE.1 == "BUS"',
                                                 'FIRE TRUCK' = 'VEHICLE.TYPE.CODE.1 == "FIRE TRUCK"',
                                                 'UTL/STN WGN' = 'VEHICLE.TYPE.CODE.1 == "SPORT UTILITY / STATION WAGON"',
                                                 'VAN' = 'VEHICLE.TYPE.CODE.1 == "VAN"',
                                                 'NA' = 'VEHICLE.TYPE.CODE.1 == ""',
                                                 'SMALL COM VEH' = 'VEHICLE.TYPE.CODE.1 == "SMALL COM VEH(4 TIRES)"',
                                                 'BIKE' = 'VEHICLE.TYPE.CODE.1 == "BICYCLE"',
                                                 'LARGE COM VEH' = 'VEHICLE.TYPE.CODE.1 == "LARGE COM VEH(6 OR MORE TIRES)"',
                                                 'PEDICAB' = 'VEHICLE.TYPE.CODE.1 == "PEDICAB"'
                                      ))
                       
      ),
      
      conditionalPanel("input.sideBarMenu == 'plot2'",
                       checkboxGroupInput('plotbor', 'Select Borough(s): ',
                                          c('Brooklyn' = 'BOROUGH == "BROOKLYN"',
                                            'Bronx' = 'BOROUGH == "BRONX"',
                                            'Queens' = 'BOROUGH == "QUEENS"',
                                            'Staten Island' = 'BOROUGH == "STATEN ISLAND"',
                                            'Manhattan' = 'BOROUGH == "MANHATTAN"'),
                                          selected = c('BOROUGH == "BROOKLYN"',
                                                       'BOROUGH == "BRONX"',
                                                       'BOROUGH == "QUEENS"',
                                                       'BOROUGH == "STATEN ISLAND"',
                                                       'BOROUGH == "MANHATTAN"')),
                       
                       checkboxGroupInput('plotyear', 'Select Year(s): ',
                                          c('2013' = 'year == "2013"',
                                            '2014' = 'year == "2014"',
                                            '2015' = 'year == "2015"',
                                            '2016' = 'year == "2016"'),
                                          selected = c('year == "2013"',
                                                       'year == "2014"',
                                                       'year == "2015"',
                                                       'year == "2016"'))
      ),
      
      conditionalPanel("input.sideBarMenu == 'injratio'",
                       sliderInput('injslide', label = 'Show up to :', 
                                   min = 1, max = 12, value = 5)
      ),
      
      conditionalPanel("input.sideBarMenu == 'motoraccidents'",
                       
                       selectizeInput('vehicle2',
                                      'VEHICLE',
                                      choice = c('All' = 'VEHICLE.TYPE.CODE.1 != "ALL"',
                                                 'TAXI' = 'VEHICLE.TYPE.CODE.1 == "TAXI"',
                                                 'LIVERY VEHICLE' = 'VEHICLE.TYPE.CODE.1 == "LIVERY VEHICLE"',
                                                 'SCOOTER' = 'VEHICLE.TYPE.CODE.1 == "SCOOTER"',
                                                 'OTHER' = 'VEHICLE.TYPE.CODE.1 == "OTHER"',
                                                 'MOTORCYCLE' = 'VEHICLE.TYPE.CODE.1 == "MOTORCYCLE"',
                                                 'AMBULANCE' = 'VEHICLE.TYPE.CODE.1 == "AMBULANCE"',
                                                 'PICK-UP TRUCK' = 'VEHICLE.TYPE.CODE.1 == "PICK-UP TRUCK"',
                                                 'UNKNOWN' = 'VEHICLE.TYPE.CODE.1 == "UNKNOWN"',
                                                 'BUS' = 'VEHICLE.TYPE.CODE.1 == "BUS"',
                                                 'FIRE TRUCK' = 'VEHICLE.TYPE.CODE.1 == "FIRE TRUCK"',
                                                 'UTL/STN WGN' = 'VEHICLE.TYPE.CODE.1 == "SPORT UTILITY / STATION WAGON"',
                                                 'VAN' = 'VEHICLE.TYPE.CODE.1 == "VAN"',
                                                 'NA' = 'VEHICLE.TYPE.CODE.1 == ""',
                                                 'SMALL COM VEH' = 'VEHICLE.TYPE.CODE.1 == "SMALL COM VEH(4 TIRES)"',
                                                 'BIKE' = 'VEHICLE.TYPE.CODE.1 == "BICYCLE"',
                                                 'LARGE COM VEH' = 'VEHICLE.TYPE.CODE.1 == "LARGE COM VEH(6 OR MORE TIRES)"',
                                                 'PEDICAB' = 'VEHICLE.TYPE.CODE.1 == "PEDICAB"'
                                      )),
                       
                       
                       selectizeInput(
                         'cause1', label = NULL, choices = unique(nyc.collisions$CONTRIBUTING.FACTOR.VEHICLE.1),
                         options = list(placeholder = 'Select Contributing Factors')
                       ),
                       
                       selectizeInput('year3',
                                      'Year',
                                      choice = c('All' = 'year != ""',
                                                 '2013' = 'year == 2013',
                                                 '2014' = 'year == 2014',
                                                 '2015' = 'year == 2015',
                                                 '2016' = 'year == 2016')),
                       
                       
                       radioButtons('fatal', 'Select data:',
                                    c('All' = 'NUMBER.OF.PERSONS.INJURED !=""',
                                      'Fatal' = 'NUMBER.OF.PERSONS.KILLED != 0'))
      ),
    
    conditionalPanel("input.sideBarMenu == 'motorcycles'",
                    
                     selectizeInput('vehicle1',
                                    'VEHICLE',
                                    choice = c('All' = 'VEHICLE.TYPE.CODE.1 != "ALL"',
                                               'TAXI' = 'VEHICLE.TYPE.CODE.1 == "TAXI"',
                                               'LIVERY VEHICLE' = 'VEHICLE.TYPE.CODE.1 == "LIVERY VEHICLE"',
                                               'SCOOTER' = 'VEHICLE.TYPE.CODE.1 == "SCOOTER"',
                                               'OTHER' = 'VEHICLE.TYPE.CODE.1 == "OTHER"',
                                               'MOTORCYCLE' = 'VEHICLE.TYPE.CODE.1 == "MOTORCYCLE"',
                                               'AMBULANCE' = 'VEHICLE.TYPE.CODE.1 == "AMBULANCE"',
                                               'PICK-UP TRUCK' = 'VEHICLE.TYPE.CODE.1 == "PICK-UP TRUCK"',
                                               'UNKNOWN' = 'VEHICLE.TYPE.CODE.1 == "UNKNOWN"',
                                               'BUS' = 'VEHICLE.TYPE.CODE.1 == "BUS"',
                                               'FIRE TRUCK' = 'VEHICLE.TYPE.CODE.1 == "FIRE TRUCK"',
                                               'UTL/STN WGN' = 'VEHICLE.TYPE.CODE.1 == "SPORT UTILITY / STATION WAGON"',
                                               'VAN' = 'VEHICLE.TYPE.CODE.1 == "VAN"',
                                               'NA' = 'VEHICLE.TYPE.CODE.1 == ""',
                                               'SMALL COM VEH' = 'VEHICLE.TYPE.CODE.1 == "SMALL COM VEH(4 TIRES)"',
                                               'BIKE' = 'VEHICLE.TYPE.CODE.1 == "BICYCLE"',
                                               'LARGE COM VEH' = 'VEHICLE.TYPE.CODE.1 == "LARGE COM VEH(6 OR MORE TIRES)"',
                                               'PEDICAB' = 'VEHICLE.TYPE.CODE.1 == "PEDICAB"'
                                    )),
                     
                     selectizeInput('year1',
                                    'Year',
                                    choice = c('All' = 'year != ""',
                                               '2013' = 'year == 2013',
                                               '2014' = 'year == 2014',
                                               '2015' = 'year == 2015',
                                               '2016' = 'year == 2016'))
                     
                     
    )
    
    
    

    ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map1",
              fluidRow(box(
                leafletOutput("map1", 
                              height = 650),
                width = 12))),
      
      tabItem(tabName = "map2",
              fluidRow(box(
                leafletOutput("map2", 
                              height = 650),
                width = 12))),
      
      tabItem(tabName = "plot",
              fluidRow(box(
                plotOutput('plot'),
                width = 12))),
      
      tabItem(tabName = "plot2",
              fluidRow(box(
                plotOutput('plot2'),
                radioButtons("plot2rad", "Group by: ",
                             c('Boroughs' = 'BOROUGH',
                               'Years' = 'year'),
                             selected = 'year'),
                width = 12))),
      
      tabItem(tabName = "table",
              fluidRow(box(
                DT::dataTableOutput("table"),
                width = 12))),
      
      tabItem(tabName = "injratio",
              fluidRow(box(
                plotOutput('injratio'),
                width = 12))),
      
      tabItem(tabName = "motorcycles",
              fluidRow(box(
                DT::dataTableOutput('motorcycles'),
                
                width = 12))),
      
      tabItem(tabName = "motoraccidents",
              fluidRow(box(
                leafletOutput("motoraccidents",
                              height = 650),
                width = 12))),
      
      tabItem(tabName = "trend",
              fluidRow(box(
                plotOutput("trend",
                              height = 500),
                radioButtons('trendradio', 'Select data:',
                             c('All' = 'NUMBER.OF.PERSONS.INJURED !=""',
                               'Hurt' = 'NUMBER.OF.PERSONS.KILLED != 0 | NUMBER.OF.PERSONS.INJURED !=0')),
                width = 12))),
      
      tabItem(tabName = 'future',
              fluidRow((box(renderText(
                'Add weekdays to maps.\n 
                Optimize map loading. \n 
                Add more features to motorcycle tabs.\n 
                Add intro tab.')
              ))))

            
      )
    )
))

