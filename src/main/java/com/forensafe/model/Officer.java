package com.forensafe.model;

public class Officer {
    private String officerId;
    private String firstName;
    private String lastName;
    private String designation;
    private String department;
    private String phone;
    private String email;
    private String role;
    private String username;
    private String password;

    public Officer() {}

    public Officer(String officerId, String firstName, String lastName,
                   String designation, String department, String phone,
                   String email, String role, String username, String password) {
        this.officerId   = officerId;
        this.firstName   = firstName;
        this.lastName    = lastName;
        this.designation = designation;
        this.department  = department;
        this.phone       = phone;
        this.email       = email;
        this.role        = role;
        this.username    = username;
        this.password    = password;
    }

    public String getFullName() { return firstName + " " + lastName; }

    // Getters & Setters
    public String getOfficerId()   { return officerId; }
    public void   setOfficerId(String v) { officerId = v; }
    public String getFirstName()   { return firstName; }
    public void   setFirstName(String v) { firstName = v; }
    public String getLastName()    { return lastName; }
    public void   setLastName(String v) { lastName = v; }
    public String getDesignation() { return designation; }
    public void   setDesignation(String v) { designation = v; }
    public String getDepartment()  { return department; }
    public void   setDepartment(String v) { department = v; }
    public String getPhone()       { return phone; }
    public void   setPhone(String v) { phone = v; }
    public String getEmail()       { return email; }
    public void   setEmail(String v) { email = v; }
    public String getRole()        { return role; }
    public void   setRole(String v) { role = v; }
    public String getUsername()    { return username; }
    public void   setUsername(String v) { username = v; }
    public String getPassword()    { return password; }
    public void   setPassword(String v) { password = v; }
}
