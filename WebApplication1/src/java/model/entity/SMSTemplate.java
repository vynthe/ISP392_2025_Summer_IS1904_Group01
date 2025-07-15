/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

import java.time.LocalDateTime;

/**
 *
 * @author exorc
 */
public class SMSTemplate {
     private int templateId;

    private String templateCode;
    private String message;
    private String useCase;
    private boolean isActive;
    private LocalDateTime createdAt;

    public SMSTemplate() {
    }

    public SMSTemplate(int templateId, String templateCode, String message, String useCase, boolean isActive, LocalDateTime createdAt) {
        this.templateId = templateId;
        this.templateCode = templateCode;
        this.message = message;
        this.useCase = useCase;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public String getTemplateCode() {
        return templateCode;
    }

    public void setTemplateCode(String templateCode) {
        this.templateCode = templateCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getUseCase() {
        return useCase;
    }

    public void setUseCase(String useCase) {
        this.useCase = useCase;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
