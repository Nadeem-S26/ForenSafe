package com.forensafe.model;

import java.sql.Date;

public class Evidence {
    private String evidenceId;
    private String caseId;
    private String storageId;
    private String evidenceType;
    private String description;
    private String serialNumber;
    private Date   seizedDate;
    private String seizedStreet;
    private String seizedArea;
    private String seizedPincode;
    private String hashValue;
    private String currentStatus;
    // computed joins
    private String caseTitle;
    private String storageLocation;

    public Evidence() {}

    // Getters & Setters
    public String getEvidenceId()      { return evidenceId; }
    public void   setEvidenceId(String v) { evidenceId = v; }
    public String getCaseId()          { return caseId; }
    public void   setCaseId(String v)  { caseId = v; }
    public String getStorageId()       { return storageId; }
    public void   setStorageId(String v){ storageId = v; }
    public String getEvidenceType()    { return evidenceType; }
    public void   setEvidenceType(String v) { evidenceType = v; }
    public String getDescription()     { return description; }
    public void   setDescription(String v) { description = v; }
    public String getSerialNumber()    { return serialNumber; }
    public void   setSerialNumber(String v){ serialNumber = v; }
    public Date   getSeizedDate()      { return seizedDate; }
    public void   setSeizedDate(Date v){ seizedDate = v; }
    public String getSeizedStreet()    { return seizedStreet; }
    public void   setSeizedStreet(String v){ seizedStreet = v; }
    public String getSeizedArea()      { return seizedArea; }
    public void   setSeizedArea(String v)  { seizedArea = v; }
    public String getSeizedPincode()   { return seizedPincode; }
    public void   setSeizedPincode(String v){ seizedPincode = v; }
    public String getHashValue()       { return hashValue; }
    public void   setHashValue(String v){ hashValue = v; }
    public String getCurrentStatus()   { return currentStatus; }
    public void   setCurrentStatus(String v){ currentStatus = v; }
    public String getCaseTitle()       { return caseTitle; }
    public void   setCaseTitle(String v){ caseTitle = v; }
    public String getStorageLocation() { return storageLocation; }
    public void   setStorageLocation(String v){ storageLocation = v; }
}
