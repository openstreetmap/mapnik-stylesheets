<Style name="world">
    <Rule>
      &maxscale_zoom0;
      &minscale_zoom9;
      <PolygonSymbolizer>
        <CssParameter name="fill">#f2efe9</CssParameter>
      </PolygonSymbolizer>
    </Rule>
</Style>
<Style name="coast-poly">
    <Rule>
      &maxscale_zoom10;
      <PolygonSymbolizer>
        <CssParameter name="fill">#f2efe9</CssParameter>
      </PolygonSymbolizer>
    </Rule>
</Style>
  <!-- BUILTUP VMAP0 -->
<Style name="builtup">
    <Rule>
      &maxscale_zoom8;
      &minscale_zoom10;
      <PolygonSymbolizer>
        <CssParameter name="fill">#ddd</CssParameter>
      </PolygonSymbolizer>
    </Rule>
</Style>

<Layer name="world" status="on" srs="&srs900913;">
    <StyleName>world</StyleName>
    <Datasource>
      <Parameter name="type">shape</Parameter>
      <Parameter name="file">&world_boundaries;/shoreline_300</Parameter>
    </Datasource>
</Layer>
<Layer name="coast-poly" status="on" srs="&srs900913;">
    <StyleName>coast-poly</StyleName>
    <Datasource>
      <Parameter name="type">shape</Parameter>
      <Parameter name="file">&world_boundaries;/processed_p</Parameter>
    </Datasource>
</Layer>
<Layer name="builtup" status="on" srs="&srsmercator;">
    <StyleName>builtup</StyleName>
    <Datasource>
      <Parameter name="type">shape</Parameter>
      <Parameter name="file">&world_boundaries;/builtup_area</Parameter>
    </Datasource>
</Layer>
