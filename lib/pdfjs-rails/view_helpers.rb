module Pdfjs
  module Rails
    module ViewHelpers
      EVERYTHING = [
        :page_selector,
        :sidebar,
        :page_buttons,
        :zoom_buttons,
        :zoom_select,
        :fullscreen,
        :bookmark,
        :open,
        :download,
        :print
      ]
      
      DEFAULT = [
        :page_buttons,
        :zoom_buttons,
        :zoom_select,
        :fullscreen,
        :download
      ]
      
      MINIMAL = [
        :page_buttons,
        :zoom_buttons,
        :download
      ]
      
      def pdf_viewer(filename, options={})
        toolbar = options.fetch(:toolbar, :default)
        
        toolbar = case toolbar
        when :everything; EVERYTHING
        when :minimal; MINIMAL
        else DEFAULT
        end unless toolbar.is_a?(Array)
        
        can_display = lambda { |arg| toolbar.member?(arg) ? '' : ' hidden' }

        html = <<-HTML
          <div id="outerContainer" dir="ltr" data-pdf=#{filename.to_json}>
            <div id="sidebarContainer">
              <div id="toolbarSidebar" class="splitToolbarButton toggled">
                <button id="viewThumbnail" class="toolbarButton group toggled" title="Show Thumbnails" tabindex="1" data-l10n-id="thumbs">
                   <span data-l10n-id="thumbs_label">Thumbnails</span>
                </button>
                <button id="viewOutline" class="toolbarButton group" title="Show Document Outline" tabindex="2" data-l10n-id="outline">
                   <span data-l10n-id="outline_label">Document Outline</span>
                </button>
                <button id="viewSearch" class="toolbarButton group hidden" title="Search Document" tabindex="3" data-l10n-id="search_panel">
                   <span data-l10n-id="search_panel_label">Search Document</span>
                </button>
              </div>
              <div id="sidebarContent">
                <div id="thumbnailView">
                </div>
                <div id="outlineView" class="hidden">
                </div>
                <div id="searchView" class="hidden">
                  <div id="searchToolbar">
                    <input id="searchTermsInput" class="toolbarField">
                    <button id="searchButton" class="textButton toolbarButton" data-l10n-id="search">Find</button>
                  </div>
                  <div id="searchResults"></div>
                </div>
              </div>
          </div>  <!-- sidebarContainer -->
          <div id="mainContainer">
            <div class="toolbar">
              <div id="toolbarContainer">
              
                <div id="toolbarViewer">
                  <div id="toolbarViewerLeft">
                        <button id="sidebarToggle" class="toolbarButton#{can_display[:sidebar]}" title="Toggle Sidebar" tabindex="4" data-l10n-id="toggle_slider">
                          <span data-l10n-id="toggle_slider_label">Toggle Sidebar</span>
                        </button>
                        <!-- <div class="toolbarButtonSpacer#{can_display[:sidebar]}"></div>-->
                    <div class="splitToolbarButton">
                      <button class="toolbarButton pageUp#{can_display[:page_buttons]}" title="Previous Page" id="previous" tabindex="5" data-l10n-id="previous">
                        <span data-l10n-id="previous_label">Previous</span>
                      </button>
                      <div class="splitToolbarButtonSeparator"></div>
                      <button class="toolbarButton pageDown#{can_display[:page_buttons]}" title="Next Page" id="next" tabindex="6" data-l10n-id="next">
                        <span data-l10n-id="next_label">Next</span>
                      </button>
                    </div>
                    <label id="pageNumberLabel" class="toolbarLabel#{can_display[:page_selector]}" for="pageNumber" data-l10n-id="page_label">Page: </label>
                    <input type="number" id="pageNumber" class="toolbarField pageNumber#{can_display[:page_selector]}" value="1" size="4" min="1" tabindex="7">
                    </input>
                    <span id="numPages" class="toolbarLabel#{can_display[:page_selector]}"></span>
                  </div>
                  <div id="toolbarViewerRight">
                    <input id="fileInput" class="fileInput" type="file" oncontextmenu="return false;" style="visibility: hidden; position: fixed; right: 0; top: 0" />


                    <button id="fullscreen" class="toolbarButton fullscreen#{can_display[:fullscreen]}" title="Fullscreen" tabindex="11" data-l10n-id="fullscreen">
                      <span data-l10n-id="fullscreen_label">Fullscreen</span>
                    </button>
                    
                    
                      <button id="openFile" class="toolbarButton openFile#{can_display[:open]}" title="Open File" tabindex="12" data-l10n-id="open_file">
                       <span data-l10n-id="open_file_label">Open</span>
                      </button>
                    
                    <button id="print" class="toolbarButton print#{can_display[:print]}" title="Print" tabindex="13" data-l10n-id="print">
                          <span data-l10n-id="print_label">Print</span>
                        </button>
                    <button id="download" class="toolbarButton download#{can_display[:download]}" title="Download" tabindex="14" data-l10n-id="download">
                      <span data-l10n-id="download_label">Download</span>
                    </button>
                    <!-- <div class="toolbarButtonSpacer"></div> -->
                    <a href="#" id="viewBookmark" class="toolbarButton bookmark#{can_display[:bookmark]}" title="Get bookmark link" tabindex="15" data-l10n-id="bookmark"><span data-l10n-id="bookmark_label">Get bookmark link</span></a>
                  </div>
                  <div class="outerCenter">
                    <div class="innerCenter" id="toolbarViewerMiddle">
                      <div class="splitToolbarButton">
                        <button class="toolbarButton zoomOut#{can_display[:zoom_buttons]}" title="Zoom Out" tabindex="8" data-l10n-id="zoom_out">
                          <span data-l10n-id="zoom_out_label">Zoom Out</span>
                        </button>
                        <div class="splitToolbarButtonSeparator#{can_display[:zoom_buttons]}"></div>
                        <button class="toolbarButton zoomIn#{can_display[:zoom_buttons]}" title="Zoom In" tabindex="9" data-l10n-id="zoom_in">
                          <span data-l10n-id="zoom_in_label">Zoom In</span>
                         </button>
                      </div>
                      <span id="scaleSelectContainer" class="dropdownToolbarButton#{can_display[:zoom_select]}">
                         <select id="scaleSelect" title="Zoom" oncontextmenu="return false;" tabindex="10" data-l10n-id="zoom">
                          <option id="pageAutoOption" value="auto" selected="selected" data-l10n-id="page_scale_auto">Automatic Zoom</option>
                          <option id="pageActualOption" value="page-actual" data-l10n-id="page_scale_actual">Actual Size</option>
                          <option id="pageFitOption" value="page-fit" data-l10n-id="page_scale_fit">Fit Page</option>
                          <option id="pageWidthOption" value="page-width" data-l10n-id="page_scale_width">Full Width</option>
                          <option id="customScaleOption" value="custom"></option>
                          <option value="0.5">50%</option>
                          <option value="0.75">75%</option>
                          <option value="1">100%</option>
                          <option value="1.25">125%</option>
                          <option value="1.5">150%</option>
                          <option value="2">200%</option>
                        </select>
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <menu type="context" id="viewerContextMenu">
              <menuitem label="Rotate Counter-Clockwise" id="page_rotate_ccw"
                        data-l10n-id="page_rotate_ccw" ></menuitem>
              <menuitem label="Rotate Clockwise" id="page_rotate_cw"
                        data-l10n-id="page_rotate_cw" ></menuitem>
            </menu>

            <div id="viewerContainer">
              <div id="viewer" contextmenu="viewerContextMenu"></div>
            </div>

            <div id="loadingBox">
              <div id="loading"></div>
              <div id="loadingBar"><div class="progress"></div></div>
            </div>

            <div id="errorWrapper" hidden='true'>
              <div id="errorMessageLeft">
                <span id="errorMessage"></span>
                <button id="errorShowMore" onclick="" oncontextmenu="return false;" data-l10n-id="error_more_info">
                  More Information
                </button>
                <button id="errorShowLess" onclick="" oncontextmenu="return false;" data-l10n-id="error_less_info" hidden='true'>
                  Less Information
                </button>
              </div>
              <div id="errorMessageRight">
                <button id="errorClose" oncontextmenu="return false;" data-l10n-id="error_close">
                  Close
                </button>
              </div>
              <div class="clearBoth"></div>
              <textarea id="errorMoreInfo" hidden='true' readonly="readonly"></textarea>
            </div>
          </div> <!-- mainContainer -->
        
        </div> <!-- outerContainer -->
      
        <script type="text/javascript">
          document.addEventListener('DOMContentLoaded', function() {
            PDFView.open(#{filename.to_json}, 0);
          }, true);
        </script>
        HTML
      
        html.html_safe
      end
    
    end
  end
end
