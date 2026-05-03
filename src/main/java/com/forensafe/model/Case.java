package com.forensafe.model;

import java.sql.Date;

public class Case {
    private String caseId;
    private String caseTitle;
    private String crimeType;
    private String description;
    private Date   dateRegistered;
    private String status;
    private String street;
    private String area;
    private String pincode;
    private int    evidenceCount;   // computed field for dashboard

    public Case() {}

    // Getters & Setters
    public String getCaseId()         { return caseId; }
    public void   setCaseId(String v) { caseId = v; }
    public String getCaseTitle()      { return caseTitle; }
    public void   setCaseTitle(String v) { caseTitle = v; }
    public String getCrimeType()      { return crimeType; }
    public void   setCrimeType(String v) { crimeType = v; }
    public String getDescription()    { return description; }
    public void   setDescription(String v) { description = v; }
    public Date   getDateRegistered() { return dateRegistered; }
    public void   setDateRegistered(Date v) { dateRegistered = v; }
    public String getStatus()         { return status; }
    public void   setStatus(String v) { status = v; }
    public String getStreet()         { return street; }
    public void   setStreet(String v) { street = v; }
    public String getArea()           { return area; }
    public void   setArea(String v)   { area = v; }
    public String getPincode()        { return pincode; }
    public void   setPincode(String v){ pincode = v; }
    public int    getEvidenceCount()  { return evidenceCount; }
    public void   setEvidenceCount(int v) { evidenceCount = v; }
}
