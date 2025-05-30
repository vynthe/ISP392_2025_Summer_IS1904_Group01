/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;
 import java.sql.Date;
/**
 *
 * @author exorc
 */
public class InvoiceDetails {
    private int invoiceDetailID;
    private int invoiceID;
    private Integer serviceID;
    private String itemName;
    private int quantity;
    private double unitPrice;
    private double subtotal;
    private String status;
    private int createdBy;
    private Date createdAt;
    private Date updatedAt;

    public InvoiceDetails() {
    }

    public InvoiceDetails(int invoiceDetailID, int invoiceID, Integer serviceID, String itemName, int quantity, double unitPrice, double subtotal, String status, int createdBy, Date createdAt, Date updatedAt) {
        this.invoiceDetailID = invoiceDetailID;
        this.invoiceID = invoiceID;
        this.serviceID = serviceID;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getInvoiceDetailID() {
        return invoiceDetailID;
    }

    public void setInvoiceDetailID(int invoiceDetailID) {
        this.invoiceDetailID = invoiceDetailID;
    }

    public int getInvoiceID() {
        return invoiceID;
    }

    public void setInvoiceID(int invoiceID) {
        this.invoiceID = invoiceID;
    }

    public Integer getServiceID() {
        return serviceID;
    }

    public void setServiceID(Integer serviceID) {
        this.serviceID = serviceID;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
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
        return "InvoiceDetails{" + "invoiceDetailID=" + invoiceDetailID + ", invoiceID=" + invoiceID + ", serviceID=" + serviceID + ", itemName=" + itemName + ", quantity=" + quantity + ", unitPrice=" + unitPrice + ", subtotal=" + subtotal + ", status=" + status + ", createdBy=" + createdBy + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
}
