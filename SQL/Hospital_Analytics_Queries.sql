USE hospital_analytics;

-- 1. List all patients.

SELECT *
FROM Patients;

-- 2. List all doctors.

SELECT *
FROM Doctors;

-- 3. Show patients older than 60.

SELECT *
FROM Patients
WHERE Age > 60;

-- 4. Show all female patients.

SELECT *
FROM Patients
WHERE Gender = 'Female';

-- 5. Show doctors ordered by salary (highest to lowest).
 
SELECT *
FROM Doctors
ORDER BY Salary DESC;

-- 6. Show completed appointments.

SELECT *
FROM Appointments
WHERE Status = 'Completed';

-- 7. Show cancelled appointments.

SELECT *
FROM Appointments
WHERE Status = 'Cancelled';

-- 8. List the first 20 appointments.

SELECT *
FROM Appointments
LIMIT 20;

-- 9. Count the total number of patients.

SELECT COUNT(*) AS TotalPatients
FROM Patients;

-- 10. Count patients by city.

SELECT City, COUNT(*) AS TotalPatients
FROM Patients
GROUP BY City;

-- 11. Calculate the average patient age.

SELECT AVG(Age) AS AverageAge
FROM Patients;

-- 12. Count total appointments.

SELECT COUNT(*) AS TotalAppointments
FROM Appointments;

-- 13. Calculate the total hospital revenue.

SELECT SUM(BillAmount) AS TotalHospitalRevenue
FROM Billing;

-- 14. Calculate the average treatment cost.

SELECT AVG(TreatmentCost) AS AverageTreatmentCost
FROM Treatments;

-- 15. Count doctors in each department.

SELECT DepartmentID, COUNT(*) AS TotalDoctors
FROM Doctors
GROUP BY DepartmentID;

-- 16. Count appointments for each doctor.

SELECT DoctorID, COUNT(*) AS TotalAppointments
FROM Appointments
GROUP BY DoctorID;

-- 17. Find the top 5 busiest doctors.

SELECT DoctorID, COUNT(*) AS TotalAppointments
FROM Appointments
GROUP BY DoctorID
ORDER BY TotalAppointments DESC
LIMIT 5;

-- 18. Calculate revenue by payment method.

SELECT PaymentMethod, SUM(BillAmount) AS TotalRevenue
FROM Billing
GROUP BY PaymentMethod;

-- 19. Find departments having more than 10 doctors.

SELECT DepartmentID, COUNT(*) AS TotalDoctors
FROM Doctors
GROUP BY DepartmentID
HAVING TotalDoctors > 10;

-- 20. Display patient names along with their appointment details.
USE hospital_analytics;

SELECT 
    p.PatientName,
    a.AppointmentID,
    a.AppointmentDate,
    a.Status,
    a.Diagnosis
FROM Patients p
JOIN Appointments a
ON p.PatientID = a.PatientID;

-- 21. Display doctor names with their department names.

USE hospital_analytics;

SELECT 
    d.DoctorName,
    dep.DepartmentName
FROM Doctors d
JOIN Departments dep
ON d.DepartmentID = dep.DepartmentID;

-- 22. Show treatment details with patient names.

SELECT 
    p.PatientName,
    t.TreatmentID,
    t.TreatmentName,
    t.TreatmentCost
FROM Treatments t
JOIN Appointments a
ON t.AppointmentID = a.AppointmentID
JOIN Patients p
ON a.PatientID = p.PatientID;

-- 23. Show billing details with patient and doctor names.

SELECT
    b.BillID,
    p.PatientName,
    d.DoctorName,
    b.BillAmount,
    b.PaymentMethod,
    b.PaymentStatus
FROM Billing b
JOIN Appointments a
ON b.AppointmentID = a.AppointmentID
JOIN Patients p
ON a.PatientID = p.PatientID
JOIN Doctors d
ON a.DoctorID = d.DoctorID;

-- 24. Display prescription details with medicine names.

SELECT
    pr.PrescriptionID,
    pr.AppointmentID,
    m.MedicineName,
    pr.Dosage,
    pr.DurationDays
FROM Prescriptions pr
JOIN Medicines m
ON pr.MedicineID = m.MedicineID;

-- 25. Find patients with multiple appointments.

SELECT
    p.PatientID,
    p.PatientName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Patients p
JOIN Appointments a
ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.PatientName
HAVING COUNT(a.AppointmentID) > 1;

-- 26. Find the most prescribed medicine.

SELECT
    m.MedicineName,
    COUNT(pr.MedicineID) AS UsageCount
FROM Prescriptions pr
JOIN Medicines m
ON pr.MedicineID = m.MedicineID
GROUP BY m.MedicineName
ORDER BY UsageCount DESC
LIMIT 1;

-- 27. Find the most common diagnosis.

SELECT
    Diagnosis,
    COUNT(*) AS TotalCases
FROM Appointments
GROUP BY Diagnosis
ORDER BY TotalCases DESC
LIMIT 1;

-- 28. Rank doctors by revenue using RANK().

SELECT
    d.DoctorID,
    d.DoctorName,
    SUM(b.BillAmount) AS TotalRevenue,
    RANK() OVER (ORDER BY SUM(b.BillAmount) DESC) AS RevenueRank
FROM Doctors d
JOIN Appointments a
ON d.DoctorID = a.DoctorID
JOIN Billing b
ON a.AppointmentID = b.AppointmentID
GROUP BY d.DoctorID, d.DoctorName;

-- 29. Show the top 3 doctors in each department using DENSE_RANK().
USE hospital_analytics;

    SELECT
    DepartmentName,
    DoctorName,
    TotalRevenue,
    DepartmentRank
FROM (
    SELECT
        dep.DepartmentName,
        d.DoctorName,
        SUM(b.BillAmount) AS TotalRevenue,
        DENSE_RANK() OVER (
            PARTITION BY dep.DepartmentID
            ORDER BY SUM(b.BillAmount) DESC
        ) AS DepartmentRank
    FROM Doctors d
    JOIN Departments dep
        ON d.DepartmentID = dep.DepartmentID
    JOIN Appointments a
        ON d.DoctorID = a.DoctorID
    JOIN Billing b
        ON a.AppointmentID = b.AppointmentID
    GROUP BY dep.DepartmentID, dep.DepartmentName, d.DoctorID, d.DoctorName
) AS RankedDoctors
WHERE DepartmentRank <= 3;

-- 30. Calculate running monthly hospital revenue using a window function.

SELECT
    DATE_FORMAT(a.AppointmentDate, '%Y-%m') AS Month,
    SUM(b.BillAmount) AS MonthlyRevenue,
    SUM(SUM(b.BillAmount)) OVER (
        ORDER BY DATE_FORMAT(a.AppointmentDate, '%Y-%m')
    ) AS RunningRevenue
FROM Billing b
JOIN Appointments a
ON b.AppointmentID = a.AppointmentID
GROUP BY DATE_FORMAT(a.AppointmentDate, '%Y-%m')
ORDER BY Month;

