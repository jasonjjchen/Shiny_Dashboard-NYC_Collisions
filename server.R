 ## server.R ##

shinyServer(function(input, output){
  
  output$trend <- renderPlot(
    group_by(filter_(nyc.collisions, input$trendradio, input$vehicle3), 
             year)%>%summarise(count = n())%>%
      ggplot(aes(x=as.integer(as.character(year)), y=count)) + 
      geom_point(size = 4, color = 'red') + 
      geom_line(size = 2, color = 'red') + theme_classic() +
      geom_text(aes(label = count), vjust = 2) +
    labs(title = 'Motor Vehicle Collisions 2013 - 2016',
         x = 'Year', y = 'Number of Accidents'),
    height = 500
    
  )
  
  output$map1 <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Esri.WorldStreetMap")%>%
      fitBounds(min(nyc.collisions$LONGITUDE), min(nyc.collisions$LATITUDE), 
                max(nyc.collisions$LONGITUDE), max(nyc.collisions$LATITUDE))
    })
  
  observeEvent(input$vehicle,
               {observeEvent(input$heatslide, 
               {observeEvent(input$dateRange, 
                             {observeEvent(input$time1, 
                                           {observeEvent(input$filter, 
                                                         {observeEvent(input$borough,{
    proxy <- leafletProxy("map1")%>%removeWebGLHeatmap(layerId = 'a')%>%
      addWebGLHeatmap(layerId = 'a', data = filter_(nyc.collisions, 
                                     input$filter, input$borough, input$vehicle)%>% 
                        filter_(input$time1)%>%
                        filter(DATE > input$dateRange[1] & DATE < input$dateRange[2]),
                      lng=~LONGITUDE, lat=~LATITUDE,size = input$heatslide, 
                      alphaRange = .01, opacity = .45)
  })
  })
  })
  })
  })
               })
  
  output$map2 <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldStreetMap")%>%
      fitBounds(min(collisions.killed$LONGITUDE), min(collisions.killed$LATITUDE), 
                max(collisions.killed$LONGITUDE), max(collisions.killed$LATITUDE))
    })
  observeEvent(input$borough1,
               {observeEvent(input$dateRange2, 
               {observeEvent(input$time2,
                             {observeEvent(input$circlesize,
                                           {observeEvent(input$show_vars, {
    proxy <- leafletProxy("map2")%>%clearShapes()%>%
      addCircles(data = filter_( collisions.killed,input$borough1, paste0(input$show_vars, collapse = ' | '))%>% 
                   filter(DATE > input$dateRange2[1] & DATE < input$dateRange2[2])%>%
                   filter_(input$time2),
                 ~LONGITUDE, ~LATITUDE, 
                 color = ~color, radius = ~NUMBER.OF.PERSONS.KILLED*input$circlesize)
    
  })
  })
  })
               })
  })
   
   
   
  output$plot <- renderPlot(
    ggplot(summarise(group_by(filter_(nyc.collisions, input$plot, input$vehicle4),year,BOROUGH),count = n()), 
           aes(x=year, y=count)) + facet_grid(~ BOROUGH) +
      geom_bar(stat = 'identity', aes(fill = BOROUGH)) +
      scale_fill_brewer(palette = 'Pastel1') +
      theme_classic()
    )
  
  output$plot2 <- renderPlot(
    ggplot(filter_(collisions.weekday, paste0(input$plotbor, collapse=' | '), 
                   paste0(input$plotyear, collapse = ' | ')), 
           aes(x=weekday, y= count)) + 
      geom_bar(stat = 'identity', aes_string(fill = input$plot2rad)) +
      scale_fill_brewer(palette = 'Pastel1') +
      facet_grid(as.formula(paste("~", input$plot2rad))) +
      scale_x_discrete(label=abbreviate) +
      theme_classic()
      )
  
  data2 <- reactive({print(input$injratio)})
  
  
  output$injratio <- renderPlot(
    ggplot(head(arrange(inj.ratio,desc(ratio)), n= input$injslide),
           aes(x = VEHICLE.TYPE.CODE.1, y = ratio)) + 
      geom_bar(stat = 'identity', aes(fill = VEHICLE.TYPE.CODE.1)) +
      scale_fill_brewer(palette = 'Set3') +
      theme_classic()
  )
  
  output$motorcycles <- DT::renderDataTable({
    datatable(arrange(
      
      group_by(
        filter_(nyc.collisions, input$vehicle1, input$year1),
        
        
        CONTRIBUTING.FACTOR.VEHICLE.1)%>%
        summarise(total.deaths = sum(NUMBER.OF.PERSONS.KILLED),
                  total.injuries = sum(NUMBER.OF.PERSONS.INJURED),
                  total.accidents = n())%>%
        mutate(ratio = (total.injuries + total.deaths)/total.accidents)%>%
        arrange(desc(total.accidents)),#%>%
        #filter(CONTRIBUTING.FACTOR.VEHICLE.1 != '', CONTRIBUTING.FACTOR.VEHICLE.1 != 'Unspecified'),
      
      
      desc(total.deaths)), rownames = FALSE) %>%
    formatStyle(input$selected,
                background = 'skyblue', fontWeight = 'bold')
  })
  
  
  output$motoraccidents <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldStreetMap")%>%
      fitBounds(min(motorcycles$LONGITUDE), min(motorcycles$LATITUDE), 
                max(motorcycles$LONGITUDE), max(motorcycles$LATITUDE))
  })
  observeEvent(input$year3, {observeEvent(input$cause1, {observeEvent(input$fatal, {observeEvent(input$vehicle2, {
    proxy <- leafletProxy("motoraccidents")%>%clearMarkerClusters()%>%clearMarkers()%>%
      addCircleMarkers(data = filter(filter_(nyc.collisions, input$fatal, input$vehicle2, input$year3),
                               CONTRIBUTING.FACTOR.VEHICLE.1 == input$cause1),
                       fillOpacity = 0.5,
                       clusterOptions = markerClusterOptions(),
                 ~LONGITUDE, ~LATITUDE,
                 color = 'red',
                 popup = ~paste(UNIQUE.KEY, DATE, TIME, weekday, sep=' | '))
  })
  })
})
})
  
 
  

  output$table <- DT::renderDataTable({
    datatable(summarise(group_by(na.omit(byneighborhood),Neighborhood),
                        BOROUGH = paste0(unique(BOROUGH), collapse = ','),
                        ZIP = paste0(unique(ZIP.CODE), collapse = ','),
                        CYCLISTS.K = sum(NUMBER.OF.CYCLIST.KILLED),
                        CYCLISTS.I = sum(NUMBER.OF.CYCLIST.INJURED),
                        PEDESTRIAN.K = sum(NUMBER.OF.PEDESTRIANS.KILLED),
                        PEDESTRIAN.I = sum(NUMBER.OF.PEDESTRIANS.INJURED),
                        MOTORIST.K = sum(NUMBER.OF.MOTORIST.KILLED),
                        MOTORIST.I = sum(NUMBER.OF.MOTORIST.INJURED),
                        total.deaths = sum(NUMBER.OF.PERSONS.KILLED))%>%
                arrange(desc(total.deaths)), rownames=FALSE) %>% 
      formatStyle(input$selected,  
                  background="skyblue", fontWeight='bold')
  })
  
  
  
  
  
  
  
  
  })