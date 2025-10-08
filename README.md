# Hospital Management System - SQL Project
This project uses the [Hospital Management Dataset](https://www.kaggle.com/datasets/kanakbaghel/hospital-management-dataset) from Kaggle.
It contains data for patients, doctors, appointments, treatments, and billing.

## Overview
This project is a **Hospital Management System database** built using MySQL. It manages **patients, doctors, treatments, appointments, and billing**. The project demonstrates advanced SQL skills including **joins, aggregations, views, window functions, and reporting**.

---

## Database Schema

### Tables

1. **Doctors**
- doctor_id (PK)
- first_name
- last_name
- specialization
- phone_number
- years_experience
- hospital_branch
- email

2. **Patients**
- patient_id (PK)
- first_name
- last_name
- gender
- date_of_birth
- contact_number
- address
- registration_date
- insurance_provider
- insurance_number
- email

3. **Appointments**
- appointment_id (PK)
- patient_id (FK)
- doctor_id (FK)
- appointment_date
- appointment_time
- reason_for_visit
- status

4. **Treatment**
- treatment_id (PK)
- appointment_id (FK)
- treatment_type
- description
- cost
- treatment_date

5. **Billing**
- bill_id (PK)
- patient_id (FK)
- treatment_id (FK)
- bill_date
- amount
- payment_method
- payment_status

---

## Views / Tasks

1. **Doctorwise_Appointments**  
   Lists all appointments with patient and doctor info.  
   `SELECT * FROM Doctorwise_Appointments;`

2. **Patient_Billing_Summary**  
   Total billing per patient.  

3. **Doctor_Patient_Stats**  
   Count of patients per doctor with patient list.  

4. **Treatment_Type_Stats**  
   Most common treatments with total cost.  

5. **Billing_By_Payment_Method**  
   Total billing aggregated by payment method.  

6. **Patients_With_Multiple_Treatments**  
   Patients with more than 1 treatment, treatments listed, total bill.  

7. **Pending_Payments**  
   Patients with pending payments along with treatments.  

8. **Insurance_Billing_Summary**  
   Billing summary grouped by insurance provider, including pending amounts.

---

## Sample Queries

```sql
-- Example: Patients with pending payments
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS Patient_Name,
    SUM(b.amount) AS Total_Pending,
    GROUP_CONCAT(t.treatment_type SEPARATOR ', ') AS Treatments_List
FROM Billing b
JOIN Patients p ON b.patient_id = p.patient_id
JOIN Treatment t ON b.treatment_id = t.treatment_id
WHERE b.payment_status = 'Pending'
GROUP BY p.patient_id
ORDER BY Total_Pending DESC;
