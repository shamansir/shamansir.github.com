<?xml version="1.0" encoding="utf-8" ?>

<!-- <!DOCTYPE stylesheet [
    <!ENTITY nbsp "&#160;" >
]> --> <!-- FIXME: fails in IE -->  

<!-- Created by shaman.sir (mailto:shaman.sir@gmail.com) © 2009 -->
<!-- (http://shamansir.madfire.net) -->
<!-- based on http://ns.hr-xml.org/2_5/HR-XML-2_5/SEP/Resume.html -->

<xsl:stylesheet version="1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:r="http://ns.hr-xml.org/2007-04-15"
    xmlns:regexp="http://exslt.org/regular-expressions"
    extension-element-prefixes="regexp"    
    exclude-result-prefixes="r">
<!-- xmlns="http://www.w3.org/1999/xhtml" -->    

  <xsl:output method="xml"
              encoding="utf-8"
              standalone="yes"
              indent="yes"
              omit-xml-declaration="yes"
              media-type="text/xhtml"/>
        <!-- 
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"        
         -->    
         
  <!-- TODO: Full HResume support -->
  <!-- TODO: XSLT 2.0 and full XHTML document versions -->
  <!-- TODO: variables to switch on and off rendering of
             additional information -->
  <!-- TODO: Date format variable -->       
         
         
  <!-- =====================[ Basic Types ]================================= -->
  
  <xsl:template name="AnyDateTimeNkType">
    <xsl:param name="DateTime" />
    <!-- TODO: <xsl:variable name="$dateTimeRegex" select="" />  -->
    <span class="hr-resume-date-time">
        <xsl:choose>
            <xsl:when test="function-available('regexp:match')">
                <xsl:variable name="dateMatches" select="regexp:match($DateTime, '^(\d{4})\-(\d{2})-(\d{2})(T(\d{2}):(\d{2}):(\d{2}))?(Z|([+-])(\d{2}):(\d{2}))?$', '')" />
                <xsl:choose>
                    <xsl:when test="$dateMatches">
		                <xsl:if test="$dateMatches[6]">
		                   <span class="hr-resume-time">
		                       <span class="hr-resume-time-hour"><xsl:value-of select="$dateMatches[6]"/></span>          
		                       <span class="hr-resume-date-minute"><xsl:value-of select="$dateMatches[7]"/></span>
		                       <span class="hr-resume-date-second"><xsl:value-of select="$dateMatches[8]"/></span>
		                   </span>
		               </xsl:if>                   
		               <span class="hr-resume-date">
		                   <span class="hr-resume-date-day"><xsl:value-of select="$dateMatches[4]"/></span>          
		                   <span class="hr-resume-date-month"><xsl:value-of select="$dateMatches[3]"/></span>
		                   <span class="hr-resume-date-year"><xsl:value-of select="$dateMatches[2]"/></span>
		               </span>
		               <xsl:if test="$dateMatches[10]">
		                   <span class="hr-resume-timezone">
		                       <span class="hr-resume-timezone-sign"><xsl:value-of select="$dateMatches[10]"/></span>          
		                       <span class="hr-resume-timezone-hour"><xsl:value-of select="$dateMatches[11]"/></span>
		                       <span class="hr-resume-timezone-minute"><xsl:value-of select="$dateMatches[12]"/></span>
		                   </span>
		               </xsl:if>
		            </xsl:when>
	                <xsl:otherwise>
	                   <xsl:choose>
	                       <xsl:when test="$DateTime = 'notKnown'">
	                           not known
	                       </xsl:when>
	                       <xsl:otherwise>
	                           <xsl:value-of select="$DateTime" />
	                       </xsl:otherwise>
	                   </xsl:choose>
	                </xsl:otherwise>
	            </xsl:choose>  
            </xsl:when>
            <xsl:otherwise>
                <!-- TODO:
                    <xsl:if test="function-available('matches')">matches is avail</xsl:if>
                -->
                <xsl:value-of select="$DateTime" />
            </xsl:otherwise>
        </xsl:choose>
        
        <!--  XSL 2.0 version
	    <xsl:analyze-string regex="^(\d{{4}})\-(\d{{2}})-(\d{{2}})(T(\d{{2}}):(\d{{2}}):(\d{{2}}))?(Z|([+-])(\d{{2}}):(\d{{2}}))?$" select="$DateTime">	       
	        <xsl:matching-substring> 
	           <xsl:if test="regex-group(4)">
	               <span class="hr-resume-time">
	                   <span class="hr-resume-time-hour"><xsl:value-of select="regex-group(4)"/></span>          
	                   <span class="hr-resume-date-minute"><xsl:value-of select="regex-group(5)"/></span>
	                   <span class="hr-resume-date-second"><xsl:value-of select="regex-group(6)"/></span>
	               </span>
               </xsl:if>                   
	           <span class="hr-resume-date">
	               <span class="hr-resume-date-day"><xsl:value-of select="regex-group(3)"/></span>	        
		           <span class="hr-resume-date-month"><xsl:value-of select="regex-group(2)"/></span>
		           <span class="hr-resume-date-year"><xsl:value-of select="regex-group(1)"/></span>
	           </span>
	           <xsl:if test="regex-group(7)">
	               <span class="hr-resume-timezone">
	                   <span class="hr-resume-timezone-sign"><xsl:value-of select="regex-group(7)"/></span>          
	                   <span class="hr-resume-timezone-hour"><xsl:value-of select="regex-group(8)"/></span>
	                   <span class="hr-resume-timezone-minute"><xsl:value-of select="regex-group(9)"/></span>
	               </span>
	           </xsl:if>
	        </xsl:matching-substring>
	        <xsl:non-matching-substring>
	            <xsl:analyze-string regex="^notKnown$" select="$DateTime">
	                <xsl:matching-substring>
	                    not known
	                </xsl:matching-substring>
	                <xsl:non-matching-substring>		                
		                <xsl:value-of select="$DateTime" />		                
	                </xsl:non-matching-substring>
	            </xsl:analyze-string>
		        
	        </xsl:non-matching-substring>
	    </xsl:analyze-string> --> 
    </span>
    
    <!-- http://ns.hr-xml.org/2_5/HR-XML-2_5/CPO/DateTimeDataTypes.html -->
    <!-- http://www.xml.com/pub/a/2003/06/04/tr.html -->
    <!-- http://www.dpawson.co.uk/xsl/rev2/regex2.html -->
    <!-- TODO: Use a format, saved in variable to represent the date-time 
               (with months-names ans s.o.) -->
  </xsl:template>
  
  <xsl:template name="LocalDateNkNaType">
    <xsl:param name="Date" />
    <!-- TODO: <xsl:variable name="$dateTimeRegex" select="" />  -->
    <span class="hr-resume-date-time">
        <xsl:choose>
            <xsl:when test="function-available('regexp:match')">
                <xsl:variable name="dateMatches" select="regexp:match($Date, '^(\d{4})\-(\d{2})-(\d{2})$', '')" />
                <xsl:choose>
                    <xsl:when test="$dateMatches">              
                       <span class="hr-resume-date">
                           <span class="hr-resume-date-day"><xsl:value-of select="$dateMatches[4]"/></span>          
                           <span class="hr-resume-date-month"><xsl:value-of select="$dateMatches[3]"/></span>
                           <span class="hr-resume-date-year"><xsl:value-of select="$dateMatches[2]"/></span>
                       </span>
                    </xsl:when>
                    <xsl:otherwise>
                       <xsl:choose>
                           <xsl:when test="$Date = 'notKnown'">
                               not known
                           </xsl:when>
                           <xsl:when test="$Date = 'notApplicable'">
                               not applicable
                           </xsl:when>
                           <xsl:otherwise>
                               <xsl:value-of select="$Date" />
                           </xsl:otherwise>
                       </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>  
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$Date" />
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- TODO: XSL2.0 version -->
        
        <!-- TODO: Use a format, saved in variable to represent the date-time 
               (with months-names ans s.o.) -->
        
    </span>
  </xsl:template>  
  
  <xsl:template name="EntityIdType">
    <xsl:param name="EntityId" />
    <xsl:param name="class" /> <!-- default value ? -->
    <xsl:if test="$EntityId/@validFrom|$EntityId/@validTo">
        <span class="hr-resume-validity">Valid&#160; 
            <xsl:if test="$EntityId/@validFrom">from
                <xsl:call-template name="AnyDateTimeNkType">
                    <xsl:with-param name="DateTime" select="$EntityId/@validFrom" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$EntityId/@validTo">to
                <xsl:call-template name="AnyDateTimeNkType">
                    <xsl:with-param name="DateTime" select="$EntityId/@validTo" />
                </xsl:call-template>
            </xsl:if>
        </span>
    </xsl:if>
    <xsl:if test="$EntityId/@idOwner">
        <span class="hr-resume-entity-owner">
            <xsl:value-of select="$EntityId/@idOwner" />
        </span>
    </xsl:if>
    <span class="hr-resume-entity-ids {$class}"> <!-- make LI ? -->
        <xsl:for-each select="$EntityId/r:IdValue">
            <span class="hr-resume-entity-id">
	            <xsl:if test="@name">
	                <span class="hr-resume-entity-id-name">
	                    <xsl:value-of select="@name" />:
	                </span>	                
	            </xsl:if>
	            <xsl:value-of select="." />
            </span>
        </xsl:for-each>
    </span>
  </xsl:template>  
  
  <xsl:template name="TelcomNumber">
    <xsl:param name="TelcomNumber" />
    <xsl:if test="$TelcomNumber/r:FormattedNumber">
        <span class="hr-resume-tcom-number">
            <xsl:value-of select="$TelcomNumber/r:FormattedNumber" />
        </span>
    </xsl:if>
    <xsl:if test="$TelcomNumber/r:SubscriberNumber">
        <span class="hr-resume-phone-number">
            <xsl:if test="$TelcomNumber/r:InternationalCountryCode">
                <span class="hr-resume-tcom-itu">
                    <xsl:value-of select="$TelcomNumber/r:InternationalCountryCode" />
                </span>
            </xsl:if>
            <xsl:if test="$TelcomNumber/r:NationalNumber">
                <span class="hr-resume-tcom-national-num">
                    <xsl:value-of select="$TelcomNumber/r:NationalNumber" />
                </span>
            </xsl:if>
            <xsl:if test="$TelcomNumber/r:AreaCityCode">
                <span class="hr-resume-tcom-acc">
                    <xsl:value-of select="$TelcomNumber/r:AreaCityCode" />
                </span>
            </xsl:if>
            <xsl:value-of select="$TelcomNumber/r:SubscriberNumber" />
            <xsl:if test="$TelcomNumber/r:Extension">
                <span class="hr-resume-tcom-ext">
                    <xsl:value-of select="$TelcomNumber/r:Extension" />
                </span>
            </xsl:if>
        </span>        
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="MobileTelcomNumber">
    <xsl:param name="MobileTelcomNumber" />
    <xsl:if test="$MobileTelcomNumber/@smsEnabled">
        <span class="hr-resume-phone-sms">&#160;</span>
    </xsl:if>
    <xsl:call-template name="TelcomNumber">
        <xsl:with-param name="TelcomNumber" select="$MobileTelcomNumber" />
    </xsl:call-template>
  </xsl:template>  
  
  <xsl:template name="ContactMethod">
    <xsl:param name="ContactMethod" />
    <dl class="hr-resume-contact-method">
        <xsl:if test="$ContactMethod/r:Use">
            <dt>Use:</dt>
            <dd class="hr-resume-contact-use">
                <xsl:value-of select="$ContactMethod/r:Use" />
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:Location">
            <dt>Location:</dt>
            <dd class="hr-resume-contact-loc">
                <xsl:value-of select="$ContactMethod/r:Location" />
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:WhenAvailable">
            <dt>Available:</dt>
            <dd class="hr-resume-contact-availty">
                <xsl:value-of select="$ContactMethod/r:WhenAvailable" />
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:Telephone">
            <dt>Telephone:</dt>
            <dd class="hr-resume-contact-telephone">
                <xsl:call-template name="TelcomNumber">
                    <xsl:with-param name="TelcomNumber" select="$ContactMethod/r:Telephone" />
                </xsl:call-template>
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:Mobile">
            <dt>Mobile:</dt>
            <dd class="hr-resume-contact-mobile">
                <xsl:call-template name="MobileTelcomNumber">
                    <xsl:with-param name="MobileTelcomNumber" select="$ContactMethod/r:Mobile" />
                </xsl:call-template>
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:Fax">
            <dt>Fax:</dt>
            <dd class="hr-resume-contact-fax">
                <xsl:call-template name="TelcomNumber">
                    <xsl:with-param name="TelcomNumber" select="$ContactMethod/r:Fax" />
                </xsl:call-template>
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:Pager">
            <dt>Pager:</dt>
            <dd class="hr-resume-contact-pager">
                <xsl:call-template name="TelcomNumber">
                    <xsl:with-param name="TelcomNumber" select="$ContactMethod/r:Pager" />
                </xsl:call-template>
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:TTYTDD">
            <dt>TTYTDD:</dt>
            <dd class="hr-resume-contact-ttytdd">
                <xsl:call-template name="TelcomNumber">
                    <xsl:with-param name="TelcomNumber" select="$ContactMethod/r:TTYTDD" />
                </xsl:call-template>
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:InternetEmailAddress">
            <dt>E-mail:</dt>
            <dd class="hr-resume-contact-email">
                <xsl:value-of select="$ContactMethod/r:InternetEmailAddress" />
            </dd>
        </xsl:if> 
        <xsl:if test="$ContactMethod/r:InternetWebAddress">
            <dt>Website:</dt>
            <dd class="hr-resume-contact-website">
                <xsl:value-of select="$ContactMethod/r:InternetWebAddress" />
            </dd>
        </xsl:if>
        <xsl:if test="$ContactMethod/r:PostalAddress">
            <dt>Postal Address:</dt>
            <dd class="hr-resume-contact-postal">
                <xsl:value-of select="$ContactMethod/r:PostalAddress" />
            </dd>
        </xsl:if>        
    </dl>
  </xsl:template>
  
  <xsl:template name="DistributionType">
    <xsl:param name="Distribution" />
    <xsl:if test="$Distribution/@validFrom | $Distribution/@validTo">
	    <span class="hr-resume-validity">Valid&#160; 
	        <xsl:if test="$Distribution/@validFrom">from
	            <xsl:call-template name="LocalDateNkNaType">
	                <xsl:with-param name="Date" select="$Distribution/@validFrom" />
	            </xsl:call-template>
	        </xsl:if>
	        <xsl:if test="$Distribution/@validTo">to
	            <xsl:call-template name="LocalDateNkNaType">
	                <xsl:with-param name="Date" select="$Distribution/@validTo" />
	            </xsl:call-template>
	        </xsl:if>
	    </span>
    </xsl:if>
    <dl class="hr-resume-distr-params">
     <xsl:if test="$Distribution/r:Id">
         <dt>ID:</dt>
         <dd>
          <xsl:call-template name="EntityIdType">
              <xsl:with-param name="EntityId" select="$Distribution/r:Id" />
              <xsl:with-param name="class" select="hr-resume-distr-ids" />
          </xsl:call-template>
         </dd>
     </xsl:if>
     <xsl:if test="$Distribution/r:Name">
         <dt>Name:</dt>
         <dd>
             <xsl:value-of select="$Distribution/r:Name" />
         </dd>
     </xsl:if>
     <xsl:if test="$Distribution/r:ContactMethod">
         <dt>Contacts:</dt>
         <dd>
             <xsl:call-template name="ContactMethod">
                 <xsl:with-param name="ContactMethod" select="$Distribution/r:ContactMethod" />
             </xsl:call-template>
         </dd>
     </xsl:if>	        
    </dl>
  </xsl:template>

         
  <!-- =====================[ Root Elements ]=============================== -->
  
  <xsl:template name="ResumeId">
    <xsl:param name="ResumeId" />
    <dt>ID:</dt>
    <dd>
        <xsl:call-template name="EntityIdType">
            <xsl:with-param name="EntityId" select="$ResumeId" />
            <xsl:with-param name="class" select="string('hr-resume-id')" />
        </xsl:call-template>
    </dd>
  </xsl:template>   
  
  <xsl:template name="DistributionGuidelines">
    <xsl:param name="DistributionGuidelines" />
    <xsl:if test="$DistributionGuidelines/r:DistributeTo | $DistributionGuidelines/r:DoNotDistributeTo">
	    <dl id="hr-resume-distr-guidelines">
	       <xsl:if test="$DistributionGuidelines/r:DistributeTo">
			   <dt>Distribute&#160;to:</dt>
			   <dd>
			     <ul class="hr-resume-distr-allow">
				     <xsl:for-each select="$DistributionGuidelines/r:DistributeTo">
					     <li>
						     <xsl:call-template name="DistributionType">
						         <xsl:with-param name="Distribution" select="." />
						     </xsl:call-template>
					     </li>
				     </xsl:for-each>
			     </ul>
			   </dd>
		   </xsl:if>
		   <xsl:if test="$DistributionGuidelines/r:DoNotDistributeTo">
               <dt>Do not distribute&#160;to:</dt>
               <dd>
                 <ul class="hr-resume-distr-nallow">
	                 <xsl:for-each select="$DistributionGuidelines/r:DoNotDistributeTo">
		                 <li>
			                 <xsl:call-template name="DistributionType">
			                     <xsl:with-param name="Distribution" select="." />
			                 </xsl:call-template>
		                 </li>
	                 </xsl:for-each>
                 </ul>
               </dd>
           </xsl:if>
	    </dl>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="StructuredXMLResumeType">
    <xsl:param name="StructuredXMLResume" />
    <dl id="hr-resume-structured">
    <xsl:if test="$StructuredXMLResume/r:ContactInfo">
        <xsl:call-template name="ContactInfo">
            <xsl:with-param name="ContactInfo" select="$StructuredXMLResume/r:ContactInfo"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:ExecutiveSummary">
        <xsl:call-template name="ExecutiveSummary">
            <xsl:with-param name="ExecutiveSummary" select="$StructuredXMLResume/r:ExecutiveSummary"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:Objective">
        <xsl:call-template name="Objective">
            <xsl:with-param name="Objective" select="$StructuredXMLResume/r:Objective"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:EmploymentHistory">
        <xsl:call-template name="EmploymentHistory">
            <xsl:with-param name="EmploymentHistory" select="$StructuredXMLResume/r:EmploymentHistory"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:EducationHistory">
        <xsl:call-template name="EducationHistory">
            <xsl:with-param name="EducationHistory" select="$StructuredXMLResume/r:EducationHistory"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:MilitaryHistory">
        <xsl:call-template name="MilitaryHistory">
            <xsl:with-param name="MilitaryHistory" select="$StructuredXMLResume/r:MilitaryHistory"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:PatentHistory">
        <xsl:call-template name="PatentHistory">
            <xsl:with-param name="PatentHistory" select="$StructuredXMLResume/r:PatentHistory"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:PublicationHistory">
        <xsl:call-template name="PublicationHistory">
            <xsl:with-param name="PublicationHistory" select="$StructuredXMLResume/r:PublicationHistory"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:Objective">
        <xsl:call-template name="SpeakingEventsHistory">
            <xsl:with-param name="SpeakingEventsHistory" select="$StructuredXMLResume/r:SpeakingEventsHistory"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:Qualifications">
        <xsl:call-template name="Qualifications">
            <xsl:with-param name="Qualifications" select="$StructuredXMLResume/r:Qualifications"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:Languages">
        <xsl:call-template name="Languages">
            <xsl:with-param name="Languages" select="$StructuredXMLResume/r:Languages"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:Achievements">
        <xsl:call-template name="Achievements">
            <xsl:with-param name="Achievements" select="$StructuredXMLResume/r:Achievements"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:Associations">
        <xsl:call-template name="Associations">
            <xsl:with-param name="Associations" select="$StructuredXMLResume/r:Associations"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:References">
        <xsl:call-template name="References">
            <xsl:with-param name="References" select="$StructuredXMLResume/r:References"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:SecurityCredentials">
        <xsl:call-template name="SecurityCredentials">
            <xsl:with-param name="SecurityCredentials" select="$StructuredXMLResume/r:SecurityCredentials"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:ResumeAdditionalItems">
        <xsl:call-template name="ResumeAdditionalItems">
            <xsl:with-param name="ResumeAdditionalItems" select="$StructuredXMLResume/r:ResumeAdditionalItems"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:SupportingMaterials">
        <xsl:call-template name="StaffingSupportingMaterials">
            <xsl:with-param name="SupportingMaterials" select="$StructuredXMLResume/r:SupportingMaterials" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:ProfessionalAssociations"> <!-- NB: Deprecated -->
        <xsl:call-template name="ProfessionalAssociations">
            <xsl:with-param name="ProfessionalAssociations" select="$StructuredXMLResume/r:ProfessionalAssociations"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:Comments">
        <xsl:call-template name="Comments">
            <xsl:with-param name="Comments" select="$StructuredXMLResume/r:Comments"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$StructuredXMLResume/r:RevisionDate">
        <xsl:call-template name="RevisionDate">
            <xsl:with-param name="RevisionDate" select="$StructuredXMLResume/r:RevisionDate"/>
        </xsl:call-template>
    </xsl:if>
    </dl>                              
  </xsl:template>  
  
  <xsl:template name="NonXMLResumeType">
    <xsl:param name="NonXMLResume" />
    <dl id="hr-resume-text">
    <xsl:if test="$NonXMLResume/r:TextResume">
        <xsl:call-template name="TextResume">
            <xsl:with-param name="TextResume" select="$NonXMLResume/r:TextResume"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$NonXMLResume/r:LinkToResume">
        <xsl:call-template name="LinkToResume">
            <xsl:with-param name="LinkToResume" select="$NonXMLResume/r:LinkToResume"/>
        </xsl:call-template>
    </xsl:if>  
    <xsl:if test="$NonXMLResume/r:SupportingMaterials">
        <xsl:call-template name="StaffingSupportingMaterials">
            <xsl:with-param name="SupportingMaterials" select="$NonXMLResume/r:SupportingMaterials" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$NonXMLResume/r:Comments">
        <xsl:call-template name="Comments">
            <xsl:with-param name="Comments" select="$NonXMLResume/r:Comments"/>
        </xsl:call-template>
    </xsl:if> 
    <xsl:if test="$NonXMLResume/r:RevisionDate">
        <xsl:call-template name="RevisionDate">
            <xsl:with-param name="RevisionDate" select="$NonXMLResume/r:RevisionDate"/>
        </xsl:call-template>
    </xsl:if>
    </dl>         
  </xsl:template>
  
  <xsl:template name="UserArea">
    <xsl:param name="UserArea" />
    <!-- See include/import  -->
    <!-- TODO -->
  </xsl:template> 
  
  
  <!-- =====================[ Shared Types ]================================ -->
    
  <xsl:template name="Comments">
    <xsl:param name="Comments" />
    <dt>Comments:</dt>
    <dd>
        <p class="hr-resume-comments">
            <xsl:value-of select="$Comments" />
        </p>
    </dd>
  </xsl:template>   
  
  <xsl:template name="RevisionDate">
    <xsl:param name="RevisionDate" />
    <dt>Revision&#160;Date:</dt>
    <dd>
        <xsl:call-template name="AnyDateTimeNkType">
            <xsl:with-param name="DateTime" select="$RevisionDate"/>
        </xsl:call-template>
    </dd>
  </xsl:template>
  
  <xsl:template name="StaffingSupportingMaterials">
    <xsl:param name="SupportingMaterials" />
    <!-- TODO -->
    <!-- <xsl:for-each select="$SupportingMaterials/r:SupportingMaterial">
        <xsl:call-template name="StaffingSupportingMaterial">
            <xsl:with-param name="SupportingMaterial" select="." />
        </xsl:call-template>
    </xsl:for-each> -->
  </xsl:template> 
  
  <xsl:template name="StaffingSupportingMaterial">
    <xsl:param name="SupportingMaterial" />
    <!-- TODO -->
  </xsl:template>  
       
  <!-- =====================[ NonXMLResume ]================================ -->
  
  <xsl:template name="TextResume">
    <xsl:param name="TextResume" />
    <dd class="no-term">
        <p id="hr-resume-text">
            <xsl:value-of select="$TextResume" />
        </p>
    </dd>
  </xsl:template>
  
  <xsl:template name="LinkToResume">
    <xsl:param name="LinkToResume" />
    <dt>URL:</dt>
    <dd><a href="{$LinkToResume}" title="Link to the Resume" id="hr-resume-link-referrer">
        Link&#160;to&#160;the&#160;Resume
    </a></dd>
  </xsl:template>
  
  
  <!-- =====================[ StructuredXMLResume ]========================= -->
  
  <xsl:template name="ContactInfo">
    <xsl:param name="ContactInfo" />
    <dt>Contact&#160;Info:</dt>
    <dd>
	    <xsl:if test="$ContactInfo/r:PersonName">
	        <xsl:call-template name="PersonName">
	           <xsl:with-param name="PersonName" select="$ContactInfo/r:PersonName" />
	        </xsl:call-template>
	    </xsl:if>
	    <xsl:if test="$ContactInfo/r:ContactMethod">
	        <!-- <span class="hr-resume-list-label">Contacts:</span> -->
	        <ul id="hr-resume-contact-methods">
	        <xsl:for-each select="$ContactInfo/r:ContactMethod">
	            <li>
	               <xsl:call-template name="ContactMethod">
	                   <xsl:with-param name="ContactMethod" select="." />
	               </xsl:call-template>
	            </li>
            </xsl:for-each>
            </ul>
        </xsl:if>
    </dd>
  </xsl:template>
  
  <xsl:template name="ExecutiveSummary">
    <xsl:param name="ExecutiveSummary" />
    <dt>Executive&#160;Summary:</dt>
    <dd><p class="hr-resume-exec-summary">
        <xsl:value-of select="$ExecutiveSummary" />
    </p></dd>
  </xsl:template>
  
  <xsl:template name="Objective">
    <xsl:param name="Objective" />
    <dt>Objective:</dt>
    <dd><p class="hr-resume-objective">
        <xsl:value-of select="$Objective" />
    </p></dd>
  </xsl:template>
  
  <xsl:template name="EmploymentHistory">
    <xsl:param name="EmploymentHistory" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="EducationHistory">
    <xsl:param name="EducationHistory" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="LicensesAndCertifications">
    <xsl:param name="LicensesAndCertifications" />
    <dt>Licences and Certifications:</dt>
    <dd>
        <ul>
            <li><!-- TODO: --></li>
        </ul>
    </dd>
  </xsl:template>  
  
  <xsl:template name="MilitaryHistory">
    <xsl:param name="MilitaryHistory" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="PatentHistory">
    <xsl:param name="PatentHistory" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="PublicationHistory">
    <xsl:param name="PublicationHistory" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="SpeakingEventsHistory">
    <xsl:param name="SpeakingEventsHistory" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="Qualifications">
    <xsl:param name="Qualifications" />
    <xsl:if test="$Qualifications/r:QualificationSummary">
        <dt>Qualification&#160;Summary:</dt>
        <dd><p class="hr-resume-qual-summary">
            <xsl:value-of select="$Qualifications/r:QualificationSummary" />
        </p></dd>    
    </xsl:if>
    <xsl:if test="$Qualifications/r:Competency">
	    <dt>Competencies:</dt>
	    <dd><ul id="hr-resume-competencies">
	    <xsl:for-each select="$Qualifications/r:Competency">	        
	        <li>
	           <xsl:call-template name="Competency">
	               <xsl:with-param name="Competency" select="." />
	           </xsl:call-template>
	        </li>	       
	    </xsl:for-each>
	    </ul></dd>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="Languages">
    <xsl:param name="Languages" />
    <dt>Languages:</dt>
	<dd><ul id="hr-resume-languages">
	    <xsl:for-each select="$Languages/r:Language">
	       <li>
		      <xsl:call-template name="Language">
		          <xsl:with-param name="Language" select="." />
		      </xsl:call-template>
	       </li>
	    </xsl:for-each>
	</ul></dd>
  </xsl:template>
  
  <xsl:template name="Achievements">
    <xsl:param name="Achievements" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="Associations">
    <xsl:param name="Associations" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="References">
    <xsl:param name="References" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="SecurityCredentials">
    <xsl:param name="SecurityCredentials" />
    <!-- TODO -->
  </xsl:template>
  
  <xsl:template name="ResumeAdditionalItems">
    <xsl:param name="ResumeAdditionalItems" />
    <dt>Additional Items:</dt>
    <dd><ul id="hr-resume-addit-items">
    <xsl:for-each select="$ResumeAdditionalItems/r:ResumeAdditionalItem">
        <li>
	        <xsl:call-template name="ResumeAdditionalItem">
	            <xsl:with-param name="ResumeAdditionalItem" select="." />
	        </xsl:call-template>
        </li>
    </xsl:for-each>
    </ul></dd>
  </xsl:template>
  
  <xsl:template name="ProfessionalAssociations"> <!-- NB: Deprecated -->
    <xsl:param name="ProfessionalAssociations" />
    <!-- TODO -->
  </xsl:template> 
  
  <!-- [Subtypes] -->
  
  <xsl:template name="PersonName">
    <xsl:param name="PersonName" />
    <!-- TODO -->
  </xsl:template>   
  
  <xsl:template name="Competency">
    <xsl:param name="Competency" />
    <!-- TODO -->
    <span class="hr-resume-stub">none</span>
  </xsl:template>
  
  <xsl:template name="Language">
    <xsl:param name="Language" />
    <!-- TODO -->
    <span class="hr-resume-stub">none</span>
  </xsl:template> 
  
  <xsl:template name="ResumeAdditionalItem">
    <xsl:param name="ResumeAdditionalItem" />
    <!-- TODO -->
  </xsl:template>     
  
  
  <!-- =====================[ MAIN ]======================================== --> 
  
  <xsl:template match="/r:Resume">
     <div id="hr-resume" class="hresume">
        <h3>Resume</h3>
        <dl id="hr-resume-props">
        <xsl:if test="@xml:lang">
            <dt>Language:</dt>
            <dd>
                <span id="hr-resume-lang">
                    <xsl:value-of select="@xml:lang" />
                </span>
             </dd>
        </xsl:if>
        <xsl:if test="r:ResumeId">
            <xsl:call-template name="ResumeId">
                <xsl:with-param name="ResumeId" select="r:ResumeId" />
            </xsl:call-template>
        </xsl:if>
        </dl>
        <xsl:if test="r:DistributionGuidelines">
            <xsl:call-template name="DistributionGuidelines">
                <xsl:with-param name="DistributionGuidelines" select="r:DistributionGuidelines" />
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="r:StructuredXMLResume">
            <xsl:call-template name="StructuredXMLResumeType">
                <xsl:with-param name="StructuredXMLResume" select="r:StructuredXMLResume" />
            </xsl:call-template>
        </xsl:if> 
        <xsl:if test="r:NonXMLResume">
            <xsl:call-template name="NonXMLResumeType">
                <xsl:with-param name="NonXMLResume" select="r:NonXMLResume" />
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="r:UserArea"> 
            <xsl:call-template name="UserArea">
                <xsl:with-param name="UserArea" select="r:UserArea" />
            </xsl:call-template>
        </xsl:if> 
     </div>
  </xsl:template>

</xsl:stylesheet>         