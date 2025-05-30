/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;
import java.sql.Date;
public class Services {
    private int serviceID;
    private String serviceName;
    private String description;
    private double price;
    private String status;
    private int createdBy;
    private Date createdAt;
    private Date updatedAt;

    public Services() {
    }

    public Services(int serviceID, String serviceName, String description, double price, String status, int createdBy, Date createdAt, Date updatedAt) {
        this.serviceID = serviceID;
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Services{" + "serviceID=" + serviceID + ", serviceName=" + serviceName + ", description=" + description + ", price=" + price + ", status=" + status + ", createdBy=" + createdBy + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
}
