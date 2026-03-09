package com.forensafe.model;

import java.sql.Timestamp;

public class CustodyTransfer {
    private String    evidenceId;
    private int       transferNo;
    private String    fromOfficerId;
    private String    toOfficerId;
    private Timestamp transferDatetime;
    private String    purpose;
    private String    remarks;
    // computed
    private String fromOfficerName;
    private String toOfficerName;

    public CustodyTransfer() {}

    public String    getEvidenceId()        { return evidenceId; }
    public void      setEvidenceId(String v){ evidenceId = v; }
    public int       getTransferNo()        { return transferNo; }
    public void      setTransferNo(int v)   { transferNo = v; }
    public String    getFromOfficerId()     { return fromOfficerId; }
    public void      setFromOfficerId(String v){ fromOfficerId = v; }
    public String    getToOfficerId()       { return toOfficerId; }
    public void      setToOfficerId(String v){ toOfficerId = v; }
    public Timestamp getTransferDatetime()  { return transferDatetime; }
    public void      setTransferDatetime(Timestamp v){ transferDatetime = v; }
    public String    getPurpose()           { return purpose; }
    public void      setPurpose(String v)   { purpose = v; }
    public String    getRemarks()           { return remarks; }
    public void      setRemarks(String v)   { remarks = v; }
    public String    getFromOfficerName()   { return fromOfficerName; }
    public void      setFromOfficerName(String v){ fromOfficerName = v; }
    public String    getToOfficerName()     { return toOfficerName; }
    public void      setToOfficerName(String v){ toOfficerName = v; }
}
