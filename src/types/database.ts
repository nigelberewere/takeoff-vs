export type ApplicationStatus = 'draft' | 'pending_review' | 'approved' | 'rejected'
export type DocumentType = 'national_id_front' | 'national_id_back' | 'selfie' | 'license_front' | 'license_back' | 'vehicle_registration' | 'insurance'

export interface Driver { id: string; auth_user_id: string; full_name: string; email: string; phone: string; application_status: ApplicationStatus; created_at: string }
export interface Vehicle { id: string; driver_id: string; type: 'bike' | 'car' | 'van' | 'truck'; make: string | null; model: string | null; year: number | null; plate_number: string | null; color: string | null }
export interface Document { id: string; driver_id: string; document_type: DocumentType; file_url: string; uploaded_at: string }
