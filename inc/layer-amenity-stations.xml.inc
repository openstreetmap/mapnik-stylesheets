<Style name="stations">
    <Rule>
      &maxscale_zoom12;
      &minscale_zoom12;
      <Filter>[railway]='station' and not [disused]='yes'</Filter>
      <PointSymbolizer file="&symbols;/halt.png" type="png" width="4" height="4" />
    </Rule>
    <Rule>
      &maxscale_zoom13;
      &minscale_zoom14;
      <Filter>[railway]='station' and not [disused]='yes'</Filter>
      <PointSymbolizer file="&symbols;/station_small.png" type="png" width="6" height="6" />
    </Rule>
    <Rule>
      &maxscale_zoom13;
      <Filter>[railway]='station' and [disused]='yes'</Filter>
      <PointSymbolizer file="&symbols;/station_disused.png" type="png" width="6" height="6" />
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[railway]='station' and not [disused]='yes'</Filter>
      <PointSymbolizer file="&symbols;/station.png" type="png" width="9" height="9" />
    </Rule>
    <Rule>
      &maxscale_zoom13;
      &minscale_zoom14;
      <Filter>[railway]='halt' or [railway]='tram_stop' or [aerialway]='station'</Filter>
      <PointSymbolizer file="&symbols;/halt.png" type="png" width="4" height="4" />
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[railway]='halt' or [railway]='tram_stop' or [aerialway]='station'</Filter>
      <PointSymbolizer file="&symbols;/station_small.png" type="png" width="6" height="6" />
    </Rule>
    <Rule>
      &maxscale_zoom14;
      &minscale_zoom14;
      <Filter>[railway]='halt' or [railway]='tram_stop' or [aerialway]='station'</Filter>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="8" fill="#66f" dy="-8" halo_radius="1" wrap_width="0"/>
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[railway] ='halt' or [railway]='tram_stop' or [aerialway]='station'</Filter>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="10" fill="#66f" dy="-10" halo_radius="1" wrap_width="0"/>
    </Rule>
    <Rule>
      &maxscale_zoom14;
      &minscale_zoom14;
      <Filter>[railway]='station' and not [disused]='yes'</Filter>
      <TextSymbolizer name="name" fontset_name="bold-fonts" size="9" fill="#66f" dy="-8" halo_radius="1" wrap_width="0"/>
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[railway]='station' and not [disused]='yes'</Filter>
      <TextSymbolizer name="name" fontset_name="bold-fonts" size="11" fill="#66f" dy="-14" halo_radius="1" wrap_width="0"/>
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[railway]='station' and [disused]='yes'</Filter>
      <TextSymbolizer name="name" fontset_name="bold-fonts" size="9" fill="grey" dy="-9" halo_radius="1" wrap_width="0"/>
    </Rule>
</Style>

<Layer name="amenity-stations" status="on" srs="&osm2pgsql_projection;">
    <StyleName>stations</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,name,railway,aerialway,disused
      from &prefix;_point
      where railway in ('station','halt','tram_stop')
         or aerialway='station'
      ) as stations
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="amenity-stations-poly" status="on" srs="&osm2pgsql_projection;">
    <StyleName>stations</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,name,railway,aerialway,disused
      from &prefix;_polygon
      where railway in ('station','halt','tram_stop')
         or aerialway='station'
      ) as stations
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>

